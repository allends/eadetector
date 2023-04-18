//
//  Onboarding.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 3/6/23.
//

import SwiftUI

struct Onboarding: View {
    
    @State var age: Int = 16
    @State var familyHistorySelection: String = "No"
    @State var sexSelection: String = "Other"
    
    @State var onBoardingIndex: Int = 0
    
    var body: some View {
        TabView (selection: $onBoardingIndex) {
            InfoStep(onBoardingIndex: $onBoardingIndex).tag(0)
            AgeStep(onBoardingIndex: $onBoardingIndex, age: $age).tag(1)
            SexStep(onBoardingIndex: $onBoardingIndex, sexSelection: $sexSelection).tag(2)
            FamilyHistoryStep(onBoardingIndex: $onBoardingIndex, familyHistorySelection: $familyHistorySelection).tag(3)
            SummaryStep(onBoardingIndex: $onBoardingIndex, familyRisk: $familyHistorySelection, sexRisk: $sexSelection, age: $age).tag(4)
        }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always)).animation(.easeInOut, value: onBoardingIndex)
    }
}

