//
//  StatisticsView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject var healthStore: HealthStore
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
            ScrollView {
                ForEach(Activity.allActivities()) { activity in
                    VStack {
                        ActivityView(activity: activity, repository: healthStore)
                        Text(activity.name)
                    }
                }
            }
            Spacer()
        }
        
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
