//
//  SignUpView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI
import Amplify

struct SignUpView: View {
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal, 10)
            TextField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal, 10)
            HStack {
                Button("Sign Up", action: {
                    Task {
                        await authSessionManager.signUp(username: email, password: password, email: email)
                    }
                }).withActionButtonStyles()
                Button("Log In", action: {
                    authSessionManager.showLogin()
                })
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
