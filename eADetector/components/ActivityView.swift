//
//  GraphView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI
import HealthKit
import SwiftUICharts

struct ActivityView: View {
    let formFactor: CGSize
    var activity: Activity
    var repository: HealthStore
    @ObservedObject var viewModel: ActivityViewModel
    
    init(activity: Activity, repository: HealthStore, formFactor: CGSize) {
        self.activity = activity
        self.repository = repository
        self.formFactor = formFactor
        
        viewModel = ActivityViewModel(activity: activity, repository: repository)
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
        
    }()
    
    var body: some View {
        BarChartView(data: ChartData(values: viewModel.stats.map {(viewModel.value(from: $0.stat).desc, viewModel.value(from: $0.stat).value)}), title: activity.name, form: formFactor)
    }
}
