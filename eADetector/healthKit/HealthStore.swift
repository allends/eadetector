//
//  HealthStore.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import Foundation
import HealthKit

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

extension Date {
    static func firstDayOfWeek() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
    }
}

final class HealthStore: ObservableObject {
    
    @Published var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    private var authorized: Bool = false
    
    static let stepCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    static let heartRate = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    static let walkingSteadiness = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleWalkingSteadiness)!
    static let respitoryRate = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.respiratoryRate)!
    
    let allTypes = Set([
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
        HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
    ])
    
    static let readAccess: Set = [stepCount, heartRate, walkingSteadiness, respitoryRate ]
    
    init () {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: allTypes) { (success, error) in
            completion(success)
        }
    }
    
    func requestHealthStat(by category: String, start: Date? = nil, end: Date? = nil, completion: @escaping ([HealthStat]) -> Void) {
        guard let store = healthStore, let type = HKObjectType.quantityType(forIdentifier: typeByCategory(category: category)) else {
            return
        }
        
        // TODO: add query parameters to this section
        
        let startDate = start ?? Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let endDate = end ?? Date()
        let anchorDate = Date.firstDayOfWeek()
        let dailyComponent = DateComponents(day: 1)
        
        
        var healthStats = [HealthStat]()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: dailyComponent)
        
        query?.initialResultsHandler = { query, statistics, error  in
            statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
                let stat = HealthStat(stat: stats.sumQuantity(), date: stats.startDate)
                healthStats.append(stat)
            })
            
            completion(healthStats)
        }
        
        guard let query = query else {
            return
        }
        
        store.execute(query)
    }
    
    func typeByCategory(category: String) -> HKQuantityTypeIdentifier {
        switch category {
        case "activeEnergyBurned":
            return .activeEnergyBurned
            
        case "appleExerciseTime":
            return .appleExerciseTime
            
        case "appleStandTime":
            return .appleStandTime
            
        case "distanceWalkingRunning":
            return .distanceWalkingRunning
            
        case "stepCount":
            return .stepCount
        default:
            return .stepCount
        }
    }
}
