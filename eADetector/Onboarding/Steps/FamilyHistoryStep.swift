//
//  FamilyHistoryStep.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 3/6/23.
//

import SwiftUI

struct FamilyHistoryStep: View {
    
    @Binding var onBoardingIndex: Int
    @Binding var familyHistorySelection: String
    
    let options = ["I don't know", "Yes", "Yes, on my mother's side", "Yes, on my father's side", "No"]
    
    var body: some View {
        VStack {
            Spacer()
            Text("Risk by family history.").font(.largeTitle).bold()
            Text("Do you have a family history of Alzheimer's?")
            Picker("Select an option", selection: $familyHistorySelection) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.menu)
            Button(action: {
                print(onBoardingIndex)
                self.onBoardingIndex = onBoardingIndex + 1
            }) {
                Text("Okay!")
            }.withActionButtonStyles()
            Spacer()
        }.padding()
    }
}
