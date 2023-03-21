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
    @Binding var age: Int
    @EnvironmentObject var authSessionManager: AuthSessionManager
    
    var body: some View {
        VStack {
            Text("Risk Summary").font(.largeTitle).bold()
            Text("Thank you for providing us with your information! This will help the app be as accurate as possible.")
            Text("Age \(age)").bold()
            Text("History: \(familyRisk)")
            Button(action: {
                self.showOnboarding = false
            }) {
                // TODO: send the data that we collect to the backend
                // TODO: use callbacks to avoid passing down all the props here
                Text("Let's go!")
            }.withActionButtonStyles()
        }
    }
}
