//
//  GraphView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI
import HealthKit

struct ActivityView: View {
    var activity: Activity
    var repository: HealthStore
    @ObservedObject var viewModel: ActivityViewModel
    
    init(activity: Activity, repository: HealthStore) {
        self.activity = activity
        self.repository = repository
        
        viewModel = ActivityViewModel(activity: activity, repository: repository)
    }

    static let dateFormatter: DateFormatter = {
            
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
        
    }()
    
//    ChartPoint(label: viewModel.value(from: $0.stat).desc, xAxisLabel: ActivityViewModel.dateFormatter.string(from: $0.date), value: viewModel.value(from: $0.stat).value)
    
//    viewModel.stats.map { ChartPoint(label: viewModel.value(from: $0.stat).desc, xAxisLabel: ActivityViewModel.dateFormatter.string(from: $0.date), value: 0)}
    
    var body: some View {
        ChartView(chartPoints: viewModel.stats.map { ChartPoint(label: viewModel.value(from: $0.stat).desc, xAxisLabel: ActivityViewModel.dateFormatter.string(from: $0.date), value: viewModel.value(from: $0.stat).value)}).padding(10)
        
        List(viewModel.stats) { stat in
            VStack(alignment: .leading) {
                Text(viewModel.value(from: stat.stat).desc)
                Text(stat.date, style: .date).opacity(0.5)
            }
        }
        .navigationBarTitle("\(activity.name) \(activity.image)", displayMode: .inline).onAppear {
            print(viewModel.stats)
        }
    }
}

//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView()
//    }
//}
