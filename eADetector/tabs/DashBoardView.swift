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
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
        
    }()
    
    func getRiskLevel(input: Double) -> Text {
        if input > 1.5 {
            return Text("You are at very high risk").foregroundColor(.red)
        } else if input > 1.0 {
            return Text("You are at high risk").foregroundColor(.orange)
        } else if input > 0.5 {
            return Text("You are at moderate risk").foregroundColor(.yellow)
        } else if input > 0.3 {
            return Text("You are at low risk")
        }
        return Text("Not enough data")
    }
        
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    getRiskLevel(input: ( authSessionManager.eadScores
                                .sorted{ $0.0 < $1.0 }
                                .map { ( dateFormatter.string(from: $0.key), $0.value) }
                        .last ?? (dateFormatter.string(from: Date()), 0.0)).1).withTitleStyles()
                    Spacer()
                    eadScoreView()
                        
                    HStack {
                        VStack {
                            ActivityView(activity: steps, repository: healthStore, formFactor: ChartForm.medium)
                        }
                        VStack {
                            ActivityView(activity: heartRate, repository: healthStore, formFactor: ChartForm.medium)
                        }
                    }
                    Spacer()
                }
                Spacer()
            }.navigationTitle("Hello, \(authSessionManager.user?.first ?? "")").backgroundStyle(.background)
        }
    }
}

struct eadScoreView: View {
    
    @EnvironmentObject var authSessionManager: AuthSessionManager
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        VStack {
            if authSessionManager.eadScores.count != 0 {
                BarChartView(data: ChartData(values: authSessionManager.eadScores.sorted{ $0.0 < $1.0 }.suffix(4).map { (dateFormatter.string(from: $0.key), $0.value) }), title: "eADScore", form: ChartForm.extraLarge)
            }
        }
    }
}
