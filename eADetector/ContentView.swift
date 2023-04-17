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
    @State var showOnboarding: Bool
    @State var onBoardingIndex = 0
    
    init(showOnboarding: Bool) {
        self.showOnboarding = showOnboarding
    }
    
    var body: some View {
        VStack {
            if (showOnboarding) {
                Onboarding(showOnboarding: $showOnboarding)
            } else if (authSessionManager.user == nil) {
                VStack {
                    
                }
            }
            else {
                TabView {
                    DashBoardView()
                        .tabItem {
                            Label("Dashboard", systemImage: "house")
                        }
                    StatisticsView()
                        .tabItem {
                            Label("Statistics", systemImage: "chart.pie")
                        }
                    TestsView()
                        .tabItem {
                            Label("Tests", systemImage: "pencil.circle")
                        }
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                }.onAppear {
                    // this marks the end of the last processed data
                    let start: Date = authSessionManager.user?.endDate ?? Date()
                    // start processing up until the current time
                    let end = Date()
                    
                    // if we already did this part, then we should skip it
                    if start == end { return }
                    var activeEnergy: [HealthStat] = []
                    healthStore.requestHealthStat(by: "activeEnergyBurned", start: start, end: Date()) { hStats in
                        activeEnergy = hStats
                    }
                    authSessionManager.processHealthData(activeEnergyStat: activeEnergy)
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
