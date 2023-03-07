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
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text("Sign up").font(.largeTitle).padding(.top, 10)
            Spacer()
            TextField("Email", text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).autocapitalization(.none)
            HStack {
                TextField("First name", text: $firstName).textFieldStyle(.roundedBorder)
                TextField("Last name", text: $lastName).textFieldStyle(.roundedBorder)
            }
            SecureField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                Button("Log In", action: {
                    authSessionManager.showLogin()
                })
                Spacer()
                Button("Sign Up", action: {
                    Task {
                        await authSessionManager.signUp(username: email, password: password, email: email, firstName: firstName, lastName: lastName)
                    }
                }).withActionButtonStyles()
            }
            Spacer()
        }.padding(.all, 20)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
