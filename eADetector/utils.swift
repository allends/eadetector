//
//  utils.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 4/15/23.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

func averageGroupsOfSeven(numbers: [Double]) -> [Double] {
    var averages: [Double] = []
    let groupSize = 7
    
    // Calculate the largest multiple of seven in terms of groups.
       let largestMultipleOfSeven = (numbers.count / groupSize) * groupSize

    for i in stride(from: 0, to: largestMultipleOfSeven, by: groupSize) {
        let endIndex = min(i + groupSize, numbers.count)
        let group = numbers[i..<endIndex]
        let sum = group.reduce(0, +)
        let average = sum / Double(group.count)
        averages.append(average)
    }

    return averages
}

func nearestPastMonday(from: Date? = nil) -> Date {
    let calendar: Calendar = Calendar.current
    let now = from ?? Date()
    
    // Get the current weekday (1 for Sunday, 2 for Monday, ..., 7 for Saturday)
    let currentWeekday = calendar.component(.weekday, from: now)
    
    // Calculate the number of days to go back to get the nearest past Monday
    let daysToSubtract = currentWeekday == 1 ? 6 : currentWeekday - 2
    
    // Subtract the calculated number of days from the current date
    let nearestMonday = calendar.date(byAdding: .day, value: -daysToSubtract, to: now)!
    
    return nearestMonday
}
