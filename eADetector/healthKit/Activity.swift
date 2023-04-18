//
//  Activity.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import Foundation

struct Activity: Identifiable, Hashable {
    var id: String
    var name: String
    var image: String
    
    static func allActivities() -> [Activity] {
        return [
            Activity(id: "oxygenSaturation", name: "Oxygen Saturation", image: "🧘"),
            Activity(id: "activeEnergyBurned", name: "Active Energy", image: "⚡️"),
            Activity(id: "sleepAnalysis", name: "Sleep Analysis", image: "💤"),
            Activity(id: "stepCount", name: "Step Count", image: "👣"),
            Activity(id: "appleStandTime", name: "Standing Time", image: "🧍‍♂️"),
            Activity(id: "restingHeartRate", name: "Resting Heart Rate", image: "❤️"),
        ]
    }
}
