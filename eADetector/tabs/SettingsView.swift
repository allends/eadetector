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
    
    // TODO: make it such that we can connect healthKit
    // TODO: make it such that we can push notifications
    // TODO: make it such that we can view legal information
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings").withTitleStyles()
                Spacer()
            }
            Spacer()
            Button("Sign out", action: {
                Task {
                    await authSessionManager.signOut()
                }
            }).buttonStyle(.bordered)
            Spacer()
            Button("Request healthkit access", action: {
                healthStore.requestAuthorization { success in
                    print("Connected health data")
                }
            })
            Spacer()
        }
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
