//
//  ConfirmationView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @State var verificationCode = ""
    let username: String
    
    var body: some View {
        VStack {
            TextField("Verification Code", text: $verificationCode).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal, 10)
            HStack {
                Button("Enter", action: {
                    Task {
                        await authSessionManager.confirmSignUp(for: username, with: verificationCode)
                    }
                }).withActionButtonStyles()
                Button("Resend", action: {
                    Task {
                        await authSessionManager.resendVerificationCode(username: username)
                    }
                }).buttonStyle(.bordered)
            }
        }
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "")
    }
}
