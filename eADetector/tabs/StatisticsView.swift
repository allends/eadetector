//
//  StatisticsView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI
import SwiftUICharts

struct StatisticsView: View {
    
    @EnvironmentObject var healthStore: HealthStore
    @State var selectedStatistic: Activity = Activity(id: "oxygenSaturation", name: "Oxygen Saturation", image: "🧘")
    // TODO: make a date picker to choose data range
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Picker("Pick statistic", selection: $selectedStatistic) {
                    ForEach(Activity.allActivities()) { activity in
                        Text(activity.name).tag(activity)
                    }
                }
                ActivityFullView(activity: selectedStatistic, repository: healthStore, formFactor: ChartForm.extraLarge).padding(10)
                NavigationLink("More", destination: MetricDetail(activity: selectedStatistic))
                Spacer()
            }.navigationTitle("Statistics")
        }
        
    }
}
