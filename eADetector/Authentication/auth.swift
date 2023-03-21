//
//  auth.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import Foundation
import Firebase
import FirebaseCore

class User {
    var email: String
    var firstName: String
    var lastName: String
    var showOnboarding: Bool
    
    init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.showOnboarding = true
    }
}

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: User)
}

final class AuthSessionManager: ObservableObject {
    
    @Published var authState: AuthState = .login
    
    init() {
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let newUser = User(email: user?.email ?? "", firstName: user?.displayName ?? "", lastName: user?.displayName ?? "")
                self.authState = .session(user: newUser)
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
                print(authResult)
            }
        }
        showLogin()
    }
    
    func resendVerificationCode(username: String) async {

    }

    func confirmSignUp(for username: String, with confirmationCode: String) async {
    }

    func signIn(username: String, password: String) {
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            print(authResult?.user)
          // ...
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

    func fetchCurrentAuthSession() async {

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

    }
    
    func updateLastName(lastName: String) async {

    }
    
    func checkOnboarding () async {

    }

    func upload() {

    }
    
}
