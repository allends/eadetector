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
    @State var showHealthKitAlert = false
        
    // TODO: make it such that we can push notifications
    // TODO: make it such that we can view legal information
    
    var body: some View {
        NavigationView() {
            List {
                NavigationLink("Profile", destination: ProfileView(first: authSessionManager.user?.first ?? "", last: authSessionManager.user?.last ?? ""))
                NavigationLink("Legal Info", destination: Text("Legal stuff placeholder"))
                Button("Sign out", action: {
                        authSessionManager.signOut()
                }).buttonStyle(.bordered)
                Button("Request healthkit access", action: {
                    healthStore.requestAuthorization { success in
                        print("Connected health data")
                    }
                    if !healthStore.checkAllPerimission() {
                        showHealthKitAlert = true
                    }
                }).buttonStyle(.bordered).alert("HealthKit Access problem detected. Check your settings!", isPresented: $showHealthKitAlert) {
                    Button("Ok", role: .cancel) {}
                }
            }.navigationTitle("Settings")
        }
    }
}
