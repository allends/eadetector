//
//  GenderStep.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 4/15/23.
//

import SwiftUI

struct SexStep: View {
    @Binding var onBoardingIndex: Int
    @Binding var sexSelection: String
    
    let options = ["Other", "Male", "Female"]
    
    var body: some View {
        VStack {
            Spacer()
            Text("Risk by sex.").font(.largeTitle).bold()
            Text("What was the sex assigned to you at birth?")
            Picker("Select an option", selection: $sexSelection) {
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

