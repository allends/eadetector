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
import FirebaseMLModelDownloader

enum AuthState {
    case signUp
    case login
    case session(user: User)
}

struct UserInfo {
    let first: String
    let last: String
    let email: String
    let showOnboarding: Bool
    let startDate: Date
    let endDate: Date
}

final class AuthSessionManager: ObservableObject {
    
    @Published var authState: AuthState = .login
    @Published var db: Firestore
    @Published var user: UserInfo?
    
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
                print(authResult?.user.uid)
                // Create a user with the uid as the document title when they sign up
                self.db.collection("users").document(authResult?.user.uid ?? "error").setData([
                    "first": firstName,
                    "last": lastName,
                    "email": email,
                    "showOnboarding": true,
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

    func fetchCurrentAuthSession() {
        guard let user = Auth.auth().currentUser else { return }
        let userRef = db.collection("users").document(user.uid)
        userRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        print("data", data)
                        let newUser = UserInfo(
                            first: data["first"] as? String ?? "",
                            last: data["last"] as? String ?? "",
                            email: data["email"] as? String ?? "",
                            showOnboarding: data["showOnboarding"] as? Bool ?? false,
                            startDate: (data["start"] as? Timestamp)?.dateValue() ?? Date(),
                            endDate: (data["end"] as? Timestamp)?.dateValue() ?? Date()
                        )
                        print(newUser)
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

    func uploadOnboardingData(familyRisk: String, age: Int) async {
        guard let user = Auth.auth().currentUser else { return }
        let options = ["No", "I don't know", "Yes, on my father's side", "Yes, on my mother's side"]
        let riskNumber = options.firstIndex(of: familyRisk) ?? 0
        do {
            try await db.collection("users").document(user.uid).setData([
                "age": age,
                "familyRiskLevel": riskNumber
            ], merge: true)
        } catch {
            print("error uploading onboarding info")
        }
        fetchCurrentAuthSession()
    }
    
    func processHealthData(activeEnergyStat: [HealthStat]) {
        guard let user = Auth.auth().currentUser else { return }
    }
    
}
