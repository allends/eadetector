//
//  eADetectorApp.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/26/23.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct eADetectorApp: App {
    
    @ObservedObject var authSessionManager = AuthSessionManager()
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(authSessionManager)
        }
    }
}
