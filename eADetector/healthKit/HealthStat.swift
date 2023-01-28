//
//  HealthStat.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import Foundation
import HealthKit

struct HealthStat: Identifiable {
    let id = UUID()
    let stat: HKQuantity?
    let date: Date
}
