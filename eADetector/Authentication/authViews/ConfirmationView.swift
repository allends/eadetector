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
            Text("Confirm your account").font(.largeTitle)
            Spacer()
            TextField("Verification Code", text: $verificationCode).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal, 10)
            HStack {
                Button("Enter", action: {
                }).withActionButtonStyles()
                Button("Resend", action: {
                }).buttonStyle(.bordered)
            }
            Spacer()
        }
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "")
    }
}
