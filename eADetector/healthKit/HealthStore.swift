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
    
    static let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
    static let appleStandTime = HKObjectType.quantityType(forIdentifier: .appleStandTime)!
    static let restingHeartRate = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
    static let stepCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    static let oxygenLevels = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!
    static let sleepingWristTemperature = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleSleepingWristTemperature)!
    
    let allTypes = Set([restingHeartRate, sleepingWristTemperature, activeEnergyBurned, stepCount, appleStandTime,  oxygenLevels])
    
    static let readAccess: Set = [restingHeartRate, sleepingWristTemperature, activeEnergyBurned, stepCount, appleStandTime,  oxygenLevels]
    
    init () {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func checkAllPerimission() -> Bool {
        guard let healthStore = self.healthStore else { return false }
        let energyShared = healthStore.authorizationStatus(for: HealthStore.activeEnergyBurned) == .sharingAuthorized
        let standShared = healthStore.authorizationStatus(for: HealthStore.appleStandTime) == .sharingAuthorized
        let heartShared = healthStore.authorizationStatus(for: HealthStore.restingHeartRate) == .sharingAuthorized
        let stepShared = healthStore.authorizationStatus(for: HealthStore.stepCount) == .sharingAuthorized
        let oxygenShared = healthStore.authorizationStatus(for: HealthStore.oxygenLevels) == .sharingAuthorized
        let sleepingShared = healthStore.authorizationStatus(for: HealthStore.sleepingWristTemperature) == .sharingAuthorized
        return energyShared && standShared && heartShared && stepShared && oxygenShared && sleepingShared
    }

    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let healthStore = self.healthStore else { return }
        
        healthStore.requestAuthorization(toShare: [], read: allTypes) { (success, error) in
            completion(success)
            
            DispatchQueue.main.async {
                self.healthStore = HKHealthStore()
            }
        }
        // TODO update the ui at this part
    }
    
    func requestHealthStatAwait(by category: String, start: Date? = nil, end: Date? = nil) async -> [HealthStat] {
        guard let store = healthStore, let type = HKObjectType.quantityType(forIdentifier: typeByCategory(category: category)) else {
            return []
        }
        
        // TODO: add query parameters to this section
        
        let startDate = start ?? Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let endDate = end ?? Date()
        let anchorDate = Date.firstDayOfWeek()
        let dailyComponent = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [.strictStartDate])
        let predicateCase = HKSamplePredicate.quantitySample(type: type, predicate: predicate)
        
        var options: HKStatisticsOptions = []
        
        if category == "oxygenSaturation" || category == "restingHeartRate" {
            options = .discreteAverage
        }
        
        let asyncQuery = HKStatisticsCollectionQueryDescriptor(predicate: predicateCase, options: options, anchorDate: anchorDate, intervalComponents: dailyComponent)
        
        var results: [HealthStat] = []
                
        do {
            let rawResults: HKStatisticsCollection = try await asyncQuery.result(for: store)
            rawResults.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
                if category == "oxygenSaturation" || category == "restingHeartRate" {
                    let stat = HealthStat(stat: stats.averageQuantity(), date: stats.startDate)
                    results.append(stat)
                } else {
                    let stat = HealthStat(stat: stats.sumQuantity(), date: stats.startDate)
                    results.append(stat)
                }
                
            })
        } catch {
            print("Error info: \(error)")
        }
        return results
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
        
        var options: HKStatisticsOptions = []
        
        if category == "oxygenSaturation" || category == "restingHeartRate" {
            options = .discreteAverage
        }
        
        var healthStats = [HealthStat]()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: options, anchorDate: anchorDate, intervalComponents: dailyComponent)
        
        query?.initialResultsHandler = { query, statistics, error  in
            statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
                if category == "oxygenSaturation" || category == "restingHeartRate" {
                    let stat = HealthStat(stat: stats.averageQuantity(), date: stats.startDate)
                    healthStats.append(stat)
                } else {
                    let stat = HealthStat(stat: stats.sumQuantity(), date: stats.startDate)
                    healthStats.append(stat)
                }
            })
            if let error = error {
                print(error)
            }
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
        case "oxygenSaturation":
            return .oxygenSaturation
        case "restingHeartRate":
            return .restingHeartRate
        case "sleepAnalysis":
            return .appleSleepingWristTemperature
        case "stepCount":
            return .stepCount
        default:
            print("using fallback type")
            return .stepCount
        }
    }
}
