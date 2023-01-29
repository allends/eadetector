//
//  StatisticsView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject var healthStore: HealthStore
    @State var selectedStatistic: Activity = Activity(id: "activeEnergyBurned", name: "Active Burned Calories", image: "⚡️")
    // TODO: make a drop to switch between data
    // TODO: make a date picker to choose data range
    // TODO: display data via a graph
    
    var body: some View {
        VStack {
            HStack {
                Text("Statistics").withTitleStyles()
                Spacer()
            }
            Spacer()
            Picker("Pick statistic", selection: $selectedStatistic) {
                ForEach(Activity.allActivities()) { activity in
                    Text(activity.name).tag(activity)
                }
            }
            ActivityView(activity: selectedStatistic, repository: healthStore)
            Text(selectedStatistic.name)
            Spacer()
        }
        
    }
}

//struct StatisticsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatisticsView()
//    }
//}
