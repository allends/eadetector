//
//  SettingsView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI
import HealthKit

struct SettingsView: View {
    
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @EnvironmentObject var healthStore: HealthStore
        
    // TODO: make it such that we can push notifications
    // TODO: make it such that we can view legal information
    
    var body: some View {
        NavigationView() {
            List {
                NavigationLink("Profile", destination: ProfileView())
                NavigationLink("Legal Info", destination: Text("Legal stuff placeholder"))
                Button("Sign out", action: {
                        authSessionManager.signOut()
                }).buttonStyle(.bordered)
                Button("Request healthkit access", action: {
                    healthStore.requestAuthorization { success in
                        print("Connected health data")
                    }
                }).buttonStyle(.bordered)
            }.navigationTitle("Settings")
        }
    }
}
