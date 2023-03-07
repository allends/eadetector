//
//  InfoStep.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 3/6/23.
//

import SwiftUI

struct InfoStep: View {
    
    @Binding var onBoardingIndex: Int
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to eADetector!").font(.largeTitle).bold()
            Spacer()
            Text("To begin, we are going to collect some information from you to best callibrate our algorithm to you! Answer the questions to the best of your ability or enter 'I don't know'.")
            Spacer()
            HStack {
                Spacer()
                Text("Swipe to begin")
                Image(systemName: "arrow.right")
                Spacer()
            }
            Spacer()
        }.padding()
        
    }
}
