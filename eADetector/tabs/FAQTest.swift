//
//  FAQTest.swift
//  eADetector
//
//  Created by Sidhu Arakkal on 4/17/23.
//

import SwiftUI

struct FAQQuestion: Identifiable {
    let id = UUID()
    let text: String
    let choices: [String]
    let points: [Int]
}

struct FAQTest: View {
    @State private var answers: [String: Int] = [:]
    @State private var showingScore = false
    @State private var totalScore = 0
    
    let questions: [FAQQuestion] = [
        FAQQuestion(text: "Writing checks, paying bills, balancing checkbook", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points: [3, 2, 1, 0, 0, 1]),
        FAQQuestion(text: "Assembling tax records, business affairs, or papers", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points: [3, 2, 1, 0, 0, 1]),
        FAQQuestion(text: "Shopping alone for clothes, household necessities, or groceries", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points: [3, 2, 1, 0, 0, 1]),
        FAQQuestion(text: "Playing a game of skill, working on a hobby", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points: [3, 2, 1, 0, 0, 1]),
        FAQQuestion(text: "Heating water, making a cup of coffee, turning off stove after use", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points: [3, 2, 1, 0, 0, 1]),
        FAQQuestion(text: "Preparing a balanced mea", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points: [3, 2, 1, 0, 0, 1]),
        FAQQuestion(text: "Keeping track of current events", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points:  [3, 2, 1, 0, 0, 1]),
        FAQQuestion(text: "Paying attention to, understanding, discussing TV, book, magazine", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points: [3, 2, 1, 0, 0, 1]),
        FAQQuestion(text: "Remembering appointments, family occasions, holidays, medications", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points: [3, 2, 1, 0, 0, 1]),
        FAQQuestion(text: "Traveling out of neighborhood, driving, arranging to take buses", choices: ["Dependent", "Requires assistance", "Has difficulty but does by self", "Normal", "Never did but could do now", "Never did and would have difficulty now"], points: [3, 2, 1, 0, 0, 1])
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(questions) { question in
                    VStack {
                        Text(question.text).multilineTextAlignment(.leading)
                        Picker("Answer", selection: Binding<String>(
                            get: {
                                answers[question.id.uuidString] != nil ? question.choices[answers[question.id.uuidString]!] : "Normal"
                            },
                            set: { newValue in
                                if let index = question.choices.firstIndex(of: newValue) {
                                    answers[question.id.uuidString] = index
                                } else {
                                    answers.removeValue(forKey: question.id.uuidString)
                                }
                            }
                        )) {
                            ForEach(question.choices, id: \.self) { choice in
                                Text(choice)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 10)
                }
                Button("Submit") {
                    // Calculate total score
                    totalScore = 0
                    for question in questions {
                        if let answer = answers[question.id.uuidString] {
                            totalScore += question.points[answer]
                        }
                    }
                    showingScore = true
                }
                .padding()
                .alert(isPresented: $showingScore) {
                    Alert(title: Text("Total Score"), message: Text("Your total score is \(totalScore)"), dismissButton: Alert.Button.default(Text("OK")))
                }
            }
            .padding()
        }
    }
}
