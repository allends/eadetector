//
//  SummaryStep.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 3/6/23.
//

import SwiftUI

struct SummaryStep: View {
    
    @Binding var onBoardingIndex: Int
    @Binding var showOnboarding: Bool
    @Binding var familyRisk: String
    @Binding var sexRisk: String
    @Binding var age: Int
    @EnvironmentObject var authSessionManager: AuthSessionManager
    
    var body: some View {
        VStack {
            Text("Risk Summary").font(.largeTitle).bold()
            Text("Thank you for providing us with your information! This will help the app be as accurate as possible.")
            Text("Age \(age)")
            Text("Sex \(sexRisk)")
            Text("History: \(familyRisk)")
            Button(action: {
                self.showOnboarding = false
                Task {
                    await authSessionManager.updateOnboarding()
                    await authSessionManager.uploadOnboardingData(familyRisk: familyRisk, age: age, sexRisk: sexRisk)
                }
            }) {
                // TODO: send the data that we collect to the backend
                // TODO: use callbacks to avoid passing down all the props here
                Text("Let's go!")
            }.withActionButtonStyles()
        }
    }
}
