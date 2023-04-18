//
//  DashBoardView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI
import HealthKit
import SwiftUICharts

struct DashBoardView: View {
    
    @EnvironmentObject var healthStore: HealthStore
    @EnvironmentObject var authSessionManager: AuthSessionManager
    let activity = Activity(id: "activeEnergyBurned", name: "Active Energy", image: "⚡️")
    let steps = Activity(id: "stepCount", name: "Step Count", image: "👣")
    let heartRate = Activity(id: "restingHeartRate", name: "Resting Heart Rate", image: "❤️")
        
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    ActivityView(activity: activity, repository: healthStore, formFactor: ChartForm.extraLarge)
                    HStack {
                        VStack {
                            ActivityView(activity: steps, repository: healthStore, formFactor: ChartForm.medium)
                        }
                        VStack {
                            ActivityView(activity: heartRate, repository: healthStore, formFactor: ChartForm.medium)
                        }
                    }
                }
                Spacer()
            }.navigationTitle("Hello, \(authSessionManager.user?.first ?? "")").backgroundStyle(.background)
        }
    }
}
