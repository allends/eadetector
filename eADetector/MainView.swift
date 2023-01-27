//
//  MainView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/26/23.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var authSessionManager: AuthSessionManager

    var body: some View {

        switch authSessionManager.authState {
        case .login:
            LoginView()
                .environmentObject(authSessionManager)

        case .signUp:
            SignUpView()
                .environmentObject(authSessionManager)

        // When user registers for the first time or tries to login
        case .confirmCode(let username):
            ConfirmationView(username: username)
                .environmentObject(authSessionManager)

        // If user is signIn, show normal view
        case .session(let user):
            ContentView(user: user)
                .environmentObject(authSessionManager)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
