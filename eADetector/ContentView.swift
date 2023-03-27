//
//  ContentView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @EnvironmentObject var healthStore: HealthStore
    @State var showOnboarding: Bool = true
    @State var onBoardingIndex = 0
    
    var body: some View {
        VStack {
            if (!showOnboarding) {
            TabView {
                DashBoardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "house")
                    }
                StatisticsView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.pie")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            } else {
               Onboarding(showOnboarding: $showOnboarding)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
