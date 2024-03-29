//
//  eADetectorApp.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/26/23.
//

import SwiftUI
import Firebase

@main
struct eADetectorApp: App {
    
    @ObservedObject var authSessionManager = AuthSessionManager()
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(authSessionManager)
        }
    }
}
