//
//  Login.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/26/23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text("Welcome to eADetector").font(.largeTitle).padding(.top, 10)
            Spacer()
            TextField("Email", text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).autocapitalization(.none).autocorrectionDisabled(true)
            SecureField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                Button("Sign Up", action: {
                    authSessionManager.showSignUp()
                })
                Spacer()
                Button("Login", action: {
                    authSessionManager.signIn(username: email, password: password)
                }).withActionButtonStyles()
            }
            Spacer()
        }.padding(.all, 20)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
