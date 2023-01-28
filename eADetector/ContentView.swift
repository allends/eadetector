//
//  ContentView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/26/23.
//

import SwiftUI
import Amplify

struct ContentView: View {
    
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @EnvironmentObject var healthStore: HealthStore
    let user: User
    
    var body: some View {
        TabView {
            DashBoardView(user: user)
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

    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
