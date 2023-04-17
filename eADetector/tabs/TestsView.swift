//
//  TestsView.swift
//  eADetector
//
//  Created by Sidhu Arakkal on 4/17/23.
//

import Foundation
import SwiftUI

struct TestsView: View {
    
    // TODO: make a date picker to choose data range
    
    var body: some View {
        NavigationView {
                VStack {
                    ScrollView{
                        Spacer()
                        CardView(content: "The Memory Impairement Screen (MIS) is a brief screening tool to evaluate memory skills in a patient.", name: "Memory Impairment Screen (MIS)", date:"02/21/2020", test: "MIS")
                        Spacer()
                        CardView(content: "The Self-Administered Gerocognitive Exam (SAGE) is designed to detect early signs of cognitive impairments.", name: "Self-Administered Gerocognitive Exam (SAGE)", date:"02/2/2020", test: "SAGE")
                        Spacer()
                        CardView(content: "This quick game provides the average reaction time for a user by clicking on colored dots", name: "Reaction Time Test", date:"02/3/2020", test: "Reaction")
                        Spacer()
                    }
                }.navigationTitle("Tests")
            
        }
        
    }
}
