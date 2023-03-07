//
//  AgeStep.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 3/6/23.
//

import SwiftUI

struct AgeStep: View {
    @Binding var onBoardingIndex: Int
    @Binding var age: Int
    @FocusState private var ageIsFouced: Bool
    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            Text("Risk by age.").font(.largeTitle).bold()
            Text("How old are you?")
            TextField("age", text: Binding(get: { String(age)}, set: {age = Int($0) ?? 0})).withTextFieldStyles().keyboardType(.numberPad).focused($ageIsFouced)
            Button(action: {
                self.ageIsFouced = false
                self.onBoardingIndex = onBoardingIndex + 1
            }) {
                Text("Okay!")
            }.withActionButtonStyles()
            Spacer()
        }.padding()
    }
}
