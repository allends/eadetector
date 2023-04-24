//
//  auth.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import HealthKit

enum AuthState {
    case signUp
    case login
    case session(user: User)
}

struct UserInfo {
    let first: String
    let last: String
    let email: String
    let age: Int
    let familyRiskLevel: Int
    let sexRiskLevel: Int
    let showOnboarding: Bool
    let startDate: Date
    let endDate: Date
    let scores: [(Date, Double)]
}

func makeRequest(dataToSend: [String: [Double]]) async -> Double {
    // Set up the http request
    let url = URL(string: "https://healthkit-function-4plciervya-uc.a.run.app/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Encode the data as JSON.
    let jsonEncoder = JSONEncoder()
    guard let jsonData = try? jsonEncoder.encode(dataToSend) else {
        fatalError("Unable to encode data")
    }
    // Set the http request body
    request.httpBody = jsonData
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Unexpected response: \(String(describing: response))")
            return 0
        }

        guard let responseText = String(data: data, encoding: .utf8) else {
            print("Unable to read data")
            return 0
        }
        print(responseText)
        if let doubleValue = Double(responseText) {
            return doubleValue
        } else {
            print("Failed to convert the extracted string to Double.")
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
    return 0
}

final class AuthSessionManager: ObservableObject {
    
    @Published var authState: AuthState = .login
    @Published var db: Firestore
    @Published var user: UserInfo?
    @Published var eadScores: [Date: Double] = [:]
    @Published var sageScores: [Date: Double] = [:]
    @Published var ad8Scores: [Date: Double] = [:]
    @Published var sageRecent: (Date, Double)?
    @Published var ad8Recent: (Date, Double)?
    @Published var reactionRecent: (Date, Double)?
    @Published var faqRecent: (Date, Double)?
    
    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.authState = .session(user: user!)
                self.fetchCurrentAuthSession()
            }
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }

    func showLogin() {
        authState = .login
    }
    
    func signUp(username: String, password: String, email: String, firstName: String, lastName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                print(authResult?.user.uid)
                // Create a user with the uid as the document title when they sign up
                self.db.collection("users").document(authResult?.user.uid ?? "error").setData([
                    "first": firstName,
                    "last": lastName,
                    "email": email,
                    "showOnboarding": true,
                    "start": dateFormatter.string(from: Date()),
                    "end": dateFormatter.string(from: Date())
                ])
                self.fetchCurrentAuthSession()
            }
        }
        showLogin()
    }

    func signIn(username: String, password: String) {
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            print(authResult?.user)
            self?.fetchCurrentAuthSession()
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            showLogin()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func fetchUserMetrics() async {
        // make sure that we have a user session before we log in
        guard let user = Auth.auth().currentUser else { return }
        let userMetricRef = db.collection("users").document(user.uid).collection("metrics")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        do {
            let snapShot = try await userMetricRef.getDocuments()
            snapShot.documents.forEach { document in
                var documentData: [Date : Double] = [:]
                for (date, score) in document.data() {
                    let dateObject = dateFormatter.date(from: date) ?? Date()
                    let score = score as? Double ?? 0.0
                    documentData[dateObject] = score
                }
                let immutableData = documentData
                if document.documentID == "eadScores" {
                    DispatchQueue.main.async {
                        self.eadScores = immutableData
                    }
                } else if document.documentID == "sageScores" {
                    DispatchQueue.main.async {
                        self.sageScores = immutableData
                    }
                } else if document.documentID == "ad8Scores" {
                    DispatchQueue.main.async {
                        self.ad8Scores = immutableData
                    }
                }
            }
        } catch {
            print("error")
        }
    }

    func fetchCurrentAuthSession() {
        guard let user = Auth.auth().currentUser else { return }
        let userRef = db.collection("users").document(user.uid)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        userRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }
                
                if let document = document, document.exists {
                    
                    let data = document.data()
                    if let data = data {
                        print("data", data["scores"])
                        for const in data["scores"] as? Sequence ?? [] {
                            print(const)
                        }
                        let newUser = UserInfo(
                            first: data["first"] as? String ?? "",
                            last: data["last"] as? String ?? "",
                            email: data["email"] as? String ?? "",
                            age: data["age"] as? Int ?? 16,
                            familyRiskLevel: data["familyRiskLevel"] as? Int ?? 0,
                            sexRiskLevel: data["sexRiskLevel"] as? Int ?? 0,
                            showOnboarding: data["showOnboarding"] as? Bool ?? true,
                            startDate: (dateFormatter.date(from: data["start"] as! String)) ?? nearestPastMonday(),
                            endDate: (dateFormatter.date(from: data["end"] as! String)) ?? nearestPastMonday(),
                            scores: []
                        )
                        if let score = data["sageScores"] as? [String: Any] {
                            self.sageRecent = (dateFormatter.date(from: score["date"] as! String) ?? self.user!.startDate , score["score"] as? Double ?? 0.0)
                        }
                        if let score = data["ad8Scores"] as? [String: Any] {
                            self.ad8Recent = (dateFormatter.date(from: score["date"] as! String) ?? self.user!.startDate, score["score"] as? Double ?? 0.0)
                        }
                        if let score = data["reactionScores"] as? [String: Any] {
                            self.reactionRecent = (dateFormatter.date(from: score["date"] as! String) ?? self.user!.startDate, score["score"] as? Double ?? 0.0)
                        }
                        if let score = data["faqScores"] as? [String: Any] {
                            self.faqRecent = (dateFormatter.date(from: score["date"] as! String) ?? self.user!.startDate, score["score"] as? Double ?? 0.0)
                        }
                        self.user = newUser
                    }
                }
            }
    }
    
    func updateName(first: String, last: String) async {
        guard let user = Auth.auth().currentUser else { return }
        do {
            try await db.collection("users").document(user.uid).setData([
                "first": first,
                "last": last
            ], merge: true)
        } catch {
            print("error updating first name")
        }
        fetchCurrentAuthSession()
    }
    
    func updateOnboarding() async {
        guard let user = Auth.auth().currentUser else { return }
        do {
            try await db.collection("users").document(user.uid).setData([
                "showOnboarding": false,
            ], merge: true)
        } catch {
            print("error updating onboarding info")
        }
        fetchCurrentAuthSession()
    }

    func uploadOnboardingData(familyRisk: String, age: Int, sexRisk: String) async {
        guard let user = Auth.auth().currentUser else { return }
        let familyRiskOptions = ["No", "I don't know", "Yes, on my father's side", "Yes, on my mother's side"]
        let sexRiskOptions = ["Other", "Male", "Female"]
        let familyRiskNumber = familyRiskOptions.firstIndex(of: familyRisk) ?? 0
        let sexRiskNumber = sexRiskOptions.firstIndex(of: sexRisk) ?? 0
        do {
            try await db.collection("users").document(user.uid).setData([
                "age": age,
                "familyRiskLevel": familyRiskNumber,
                "sexRiskLevel": sexRiskNumber
            ], merge: true)
        } catch {
            print("error uploading onboarding info")
        }
        fetchCurrentAuthSession()
    }
    
    func uploadTestScores(score: (Date, Double), key: String) async {
        guard let user = Auth.auth().currentUser else { return }
        let nearestMonday = nearestPastMonday(from: score.0)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        do {
            try await db.collection("users").document(user.uid).collection("metrics").document(key).setData([
                "\(dateFormatter.string(from: nearestMonday))": score.1
            ], merge: true)
            try await db.collection("users").document(user.uid).setData([
                "\(key)": [ "score": score.1, "date": dateFormatter.string(from: nearestMonday) ]
            ], merge: true)
        } catch {
            print("error uploading \(key) info")
            return
        }
        fetchCurrentAuthSession()
    }
    
    func uploadWeeklyEADScore(scores: [(Date, Double)]) async {
        guard let user = Auth.auth().currentUser else { return }
        // map the data to a dictionary
        var formattedData: [String: Any] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for (date, score) in scores {
            formattedData["\(dateFormatter.string(from: date))"] = score
        }
        do {
            try await db.collection("users").document(user.uid).collection("metrics").document("eadScores").setData(formattedData, merge: true)
            try await db.collection("users").document(user.uid).setData([
                "end": dateFormatter.string(from: nearestPastMonday())
            ], merge: true)
        } catch {
            print("error uploading eADScore info")
            return
        }
        fetchCurrentAuthSession()
    }
    
    func processHealthData(start: Date, end: Date, activeEnergy: [HealthStat], oxygenSaturation: [HealthStat], sleepAnalysis: [HealthStat], stepCount: [HealthStat], appleStandTime: [HealthStat], heartRate: [HealthStat]) async {
        guard let user = self.user else { return }

        // process a week at a time batches of 7
        let age = Double(user.age)
        let _familyRiskLevel = Double(user.familyRiskLevel)
        let sexRiskLevel = Double(user.familyRiskLevel)
        
        // data categories
        let activeEnergyStatMapped = averageGroupsOfSeven(numbers: activeEnergy.map { $0.stat?.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0 } )
        let oxygenSaturationStatMapped = averageGroupsOfSeven(numbers: oxygenSaturation.map { ($0.stat?.doubleValue(for: HKUnit.percent())  ?? 0.0) * 100.0 } )
        let sleepAnalysisStatMapped = averageGroupsOfSeven(numbers: sleepAnalysis.map { $0.stat?.doubleValue(for: HKUnit.percent()) ?? 0.0 })
        let stepCountStatMapped = averageGroupsOfSeven(numbers: stepCount.map { $0.stat?.doubleValue(for: HKUnit.count()) ?? 0.0 })
        let appleStandTimeStatMapped = averageGroupsOfSeven(numbers: appleStandTime.map { $0.stat?.doubleValue(for: HKUnit.minute()) ?? 0.0 })
        let heartRateMapped = averageGroupsOfSeven(numbers: heartRate.map { $0.stat?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0.0 })
        let requestsNeeded = activeEnergyStatMapped.count - 1
        
        if requestsNeeded < 0 { return }
        let calendar = Calendar.current
        // make the requests
        var uploadData: [(Date, Double)] = []
        for index in 0...requestsNeeded {
            // Define the data to send.
            let dataToSend: [String: [Double]] = [
                "data": [sexRiskLevel, age, heartRateMapped[index], sleepAnalysisStatMapped[index], activeEnergyStatMapped[index], stepCountStatMapped[index], appleStandTimeStatMapped[index], oxygenSaturationStatMapped[index], 0, 0 , 0, 0, 0, 0]
            ]
            let eADScore = await makeRequest(dataToSend: dataToSend)
            let dataWeekStart = calendar.date(byAdding: .day, value: index * 7, to: start)
            uploadData.append((dataWeekStart ?? Date(), eADScore ?? 0.0))
        }
        let immutableData = uploadData
        Task {
            await uploadWeeklyEADScore(scores: immutableData)
        }
    }
    
}
