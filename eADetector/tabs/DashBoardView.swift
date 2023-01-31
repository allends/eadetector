//
//  DashBoardView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI
import HealthKit
import Charts

struct DashBoardView: View {
    
    @EnvironmentObject var healthStore: HealthStore
    let user: User
    let activity = Activity(id: "activeEnergyBurned", name: "Active Burned Calories", image: "⚡️")
    // TODO: load the user data and display a graph
    
    var body: some View {
        VStack {
            HStack {
                Text("Hello, \(user.firstName)").withTitleStyles()
                Spacer()
            }
            
            Spacer()
            VStack {
                ActivityView(activity: activity, repository: healthStore)
                Text(activity.name)
            }
            Spacer()
        }
    }
}

//struct DashBoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashBoardView()
//    }
//}
