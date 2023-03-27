//
//  auth.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import Foundation
import Firebase
import FirebaseCore

enum AuthState {
    case signUp
    case login
    case session(user: FirebaseAuth.User)
}

struct UserInfo {
    let first: String
    let last: String
    let email: String
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
                    "email": email
                ])
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
                        let newUser = UserInfo(first: data["first"] as? String ?? "", last: data["last"] as? String ?? "", email: data["email"] as? String ?? "")
                        self.user = newUser
                    }
                }
            }
    }
    
    func updateName(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
          // ...
        }
    }
    
    // TODO do some error handling on the result of the update
    func updateFirstName(firstName: String) async {
        if case let .session(user) = authState {
            print("we have a user")
            do {
                try await db.collection("users").document(user.uid).setData([
                    "first": firstName
                ], merge: true)
                fetchCurrentAuthSession()
            } catch {
                print("error occured")
            }
        } else {
            return
        }
        
        
    }
    
    func updateLastName(lastName: String) async {

    }
    
    func checkOnboarding () async {

    }

    func upload() {

    }
    
}
