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
