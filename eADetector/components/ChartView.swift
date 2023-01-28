//
//  ChartView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI
import Charts

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct ChartPoint: Identifiable {
    let id = UUID()
    let label: String
    let xAxisLabel: String
    let value: Int
}

struct ChartView: View {
    
    let chartPoints: [ChartPoint]
    
    var body: some View {
        VStack{
            Chart {
                ForEach(chartPoints) { chartPoint in
                    BarMark(x: .value("label", chartPoint.label), y: .value("another label", chartPoint.value))
                }
            }
        }
    }
}

//struct ChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        let values = [213, 343, 3, 3, 344, 435, 342, 30]
//        let labels = ["213", "343", "3", "3", "344", "435", "342", "30"]
//        let xAxisValues = ["May 30", "May 31", "June 1", "June 2", "June 3", "June 4", "June 5", "June 6"]
//        ChartView(values: values, labels: labels, xAxisLabels: xAxisValues)
//    }
//}

