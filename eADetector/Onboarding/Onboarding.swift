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
    
    @State var onBoardingIndex: Int = 0
    @Binding var showOnboarding: Bool
    
    var body: some View {
        TabView (selection: $onBoardingIndex) {
            InfoStep(onBoardingIndex: $onBoardingIndex).tag(0)
            AgeStep(onBoardingIndex: $onBoardingIndex, age: $age).tag(1)
            FamilyHistoryStep(onBoardingIndex: $onBoardingIndex, familyHistorySelection: $familyHistorySelection).tag(2)
            SummaryStep(onBoardingIndex: $onBoardingIndex, showOnboarding: $showOnboarding, familyRisk: $familyHistorySelection, age: $age).tag(3)
        }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always)).animation(.easeInOut, value: onBoardingIndex)
    }
}

