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
    @State var onBoardingIndex = 0
    
    var body: some View {
        VStack {
            if (authSessionManager.user == nil) {
                VStack {
                    Text("loading")
                }
            } else if (authSessionManager.user!.showOnboarding) {
                Onboarding()
            } else {
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

                    Task {
                        let activeEnergyStats = await healthStore.requestHealthStatAwait(by: "activeEnergyBurned", start: start, end: end)
                        let oxygenStats = await healthStore.requestHealthStatAwait(by: "oxygenSaturation", start: start, end: end)
                        let sleepAnalysis = await healthStore.requestHealthStatAwait(by: "sleepAnalysis", start: start, end: end)
                        let stepCount = await healthStore.requestHealthStatAwait(by: "stepCount", start: start, end: end)
                        let appleStandTime = await healthStore.requestHealthStatAwait(by: "appleStandTime", start: start, end: end)
                        let heartRate = await healthStore.requestHealthStatAwait(by: "restingHeartRate", start: start, end: end)
                        await authSessionManager.processHealthData(start: start, end: end, activeEnergy: activeEnergyStats, oxygenSaturation: oxygenStats, sleepAnalysis: sleepAnalysis, stepCount: stepCount, appleStandTime: appleStandTime, heartRate: heartRate)
                        await authSessionManager.fetchUserMetrics()
                        print (authSessionManager.eadScores)
                    }
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
