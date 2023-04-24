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
    @EnvironmentObject var authSessionManager: AuthSessionManager
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter
        
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView{
                    Text("Self-Administered Tests").font(.system(.title2, design: .rounded)).italic()
                    Text("These tests should be done by the patient. We recommend that both tests are done weekly, but no more often than three times a week.").italic().padding()
                    CardView(content: "The Self-Administered Gerocognitive Exam (SAGE) is designed to detect early signs of cognitive impairments. Our version includes date-related questions only.", name: "Self-Administered Gerocognitive Exam (SAGE)", date: TestsView.dateFormatter.string(from: authSessionManager.sageRecent?.0 ?? Date()) , test: "SAGE")
                    CardView(content: "This quick test provides the average reaction time for a user by clicking on colored dots", name: "Reaction Time Test", date: TestsView.dateFormatter.string(from: authSessionManager.reactionRecent?.0 ?? Date()), test: "Reaction").padding(.bottom, 25)
                    Text("Informant Tests").font(.system(.title2, design: .rounded)).italic()
                    Text("These tests should be done by an informant who is well informed about the patient. If no such person is avialble, the patient may do the tests themselves").italic().padding()
                    CardView(content: "The Ascertain Dementia 8 (AD8) is a brief tool that is used to discriminate between the symptoms of normal aging and mild dementia.", name: "Ascertain Dementia 8 (AD8)", date:TestsView.dateFormatter.string(from: authSessionManager.ad8Recent?.0 ?? Date()), test: "AD8")
                    CardView(content: "The Functional Activities Questionnaire (FAQ) measures a patient's ability to do daily activities, and monitors functional changes over time.", name: "Functional Activities Questionnaire (FAQ)", date:TestsView.dateFormatter.string(from: authSessionManager.faqRecent?.0 ?? Date()), test: "FAQ").padding(.bottom, 25)
                }
            }.navigationTitle("Tests")
            
        }
        
    }
}
