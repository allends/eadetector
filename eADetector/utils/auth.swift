//
//  auth.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import Foundation
import Amplify
import AWSCognitoAuthPlugin

class User {
    var email: String
    var authUser: AuthUser
    var firstName: String
    var lastName: String
    
    init(email: String, authUser: AuthUser, firstName: String, lastName: String) {
        self.email = email
        self.authUser = authUser
        self.firstName = firstName
        self.lastName = lastName
    }
}

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user:User)
}

final class AuthSessionManager: ObservableObject {
    
    @Published var authState: AuthState = .login
    
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
        Task(priority: .low) {
            await fetchCurrentAuthSession()
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }

    func showLogin() {
        authState = .login
    }
    
    func signUp(username: String, password: String, email: String, firstName: String, lastName: String) async {
        let userAttributes = [AuthUserAttribute(.email, value: email), AuthUserAttribute(.custom("firstName"), value: firstName), AuthUserAttribute(.custom("lastName"), value: lastName)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: username,
                password: password,
                options: options
            )
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                authState = .confirmCode(username: username)
            } else {
                print("SignUp Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func resendVerificationCode(username: String) async {
        do {
            let _resendResult = try await Amplify.Auth.resendSignUpCode(for: username)

        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func confirmSignUp(for username: String, with confirmationCode: String) async {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: confirmationCode
            )
            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
            Task {
                await fetchCurrentAuthSession()
            }
        } catch let error as AuthError {
            print("An error occurred while confirming sign up \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func signIn(username: String, password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: username,
                password: password
                )
            if signInResult.isSignedIn {
                print("Sign in succeeded")
            }
            Task {
                await fetchCurrentAuthSession()
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signOut() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }
        switch signOutResult {
            case .complete:
                await fetchCurrentAuthSession()
            case .failed(let error):
                print("Sign out ERROR ", error)
            default:
                print("error")
        }
    }

    func fetchCurrentAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("\(session)")
            print("Is user signed in - \(session.isSignedIn)")
            if (session.isSignedIn) {
                let user = try await Amplify.Auth.getCurrentUser()
                let userAtt = try await Amplify.Auth.fetchUserAttributes()
                // load the email from the user attributes field
                print(userAtt)
                let firstName = userAtt.first(where: { $0.key == .custom("firstName") })?.value ?? ""
                let lastName = userAtt.first(where: { $0.key == .custom("lastName") })?.value ?? ""
                let currentUser = User(email: userAtt.first(where: { $0.value.contains("@")})?.value ?? "", authUser: user, firstName: firstName, lastName: lastName)
                DispatchQueue.main.async {
                    self.authState = .session(user: currentUser)
                }
            } else {
                DispatchQueue.main.async {
                    self.authState = .login
                }
            }
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
}




