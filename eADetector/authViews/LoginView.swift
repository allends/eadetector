//
//  Login.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/26/23.
//

import SwiftUI
import Amplify

struct LoginView: View {
    
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal, 10)
            TextField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal, 10)
            HStack {
                Button("Login", action: {
                    Task {
                        await authSessionManager.signIn(username: email, password: password)
                    }
                })
                Button("Sign Up", action: {
                    authSessionManager.showSignUp()
                })
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
