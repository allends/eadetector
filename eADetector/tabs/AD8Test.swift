//
//  AD8Test.swift
//  eADetector
//
//  Created by Sidhu Arakkal on 4/17/23.
//

import SwiftUI

struct AD8Question: Identifiable {
    let id = UUID()
    let text: String
    let answers: [String]
}

struct AD8QuestionView: View {
    @Binding var questions: [AD8Question]
    @Binding var selectedAnswers: [Int?]
    var i: Int
    @Binding var submitted: Bool
    var body: some View {
        VStack {
            Text(questions[i].text)
                .font(.headline)
                .padding(.bottom, 1)
                .multilineTextAlignment(.leading)
            ForEach(0..<questions[i].answers.count) { j in
                HStack {
                    Text(questions[i].answers[j])
                    Spacer()
                    if submitted {
                        Image(systemName: selectedAnswers[i] == j ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedAnswers[i] == j ? .blue : .gray)
                            .onTapGesture {
                                // Allow changing answer only if not yet submitted
                                if !submitted {
                                    selectedAnswers[i] = j
                                }
                            }
                    } else {
                        Image(systemName: selectedAnswers[i] == j ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedAnswers[i] == j ? .blue : .gray)
                            .onTapGesture {
                                // Allow changing answer only if not yet submitted
                                if !submitted {
                                    selectedAnswers[i] = j
                                }
                            }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 1, trailing: 5))
            }
        }
    }
}


struct AD8Test: View {
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @State private var questions: [AD8Question] = [
        AD8Question(text: "Problems with judgment (e.g., problems making decisions, bad financial decisions, problems with thinking)", answers: ["YES, A Change", "NO, No Change", "N/A, Don't Know"]),
        AD8Question(text: "Less interest in hobbies/activities", answers: ["YES, A Change", "NO, No Change", "N/A, Don't Know"]),
        AD8Question(text: "Repeats the same things over and over (questions, stories, or statements)", answers: ["YES, A Change", "NO, No Change", "N/A, Don't Know"]),
        AD8Question(text: "Trouble learning how to use a tool, appliance, or gadget (e.g., VCR, computer, microwave, remote control)", answers: ["YES, A Change", "NO, No Change", "N/A, Don't Know"]),
        AD8Question(text: "Forgets correct month or year", answers: ["YES, A Change", "NO, No Change", "N/A, Don't Know"]),
        AD8Question(text: "Trouble handling complicated financial affairs (e.g., balancing checkbook, income taxes, paying bills)", answers: ["YES, A Change", "NO, No Change", "N/A, Don't Know"]),
        AD8Question(text: "Trouble remembering appointments", answers: ["YES, A Change", "NO, No Change", "N/A, Don't Know"]),
        AD8Question(text: "Daily problems with thinking and/or memory", answers: ["YES, A Change", "NO, No Change", "N/A, Don't Know"])
    ]
    @State private var selectedAnswers: [Int?] = [nil, nil, nil, nil, nil, nil, nil, nil]
    @State private var submitted = false
    
    var body: some View {
        ScrollView {
        VStack {
            ForEach(0..<questions.count) { i in
                AD8QuestionView(questions: $questions, selectedAnswers: $selectedAnswers, i: i, submitted: $submitted)
            }
            .padding(.bottom, 20)
            Button(action: {
                submitted = true
                Task {
                    await authSessionManager.uploadTestScores(score: (Date(), Double(calculateScore())), key: "ad8Scores")
                }
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            if submitted {
                Text("Score: \(calculateScore())")
                    .font(.headline)
                    .padding()
            }
        }
        .padding()
    }
    
}

func calculateScore() -> Int {
    var score = 0
    for i in 0..<questions.count {
        if selectedAnswers[i] == 0 {
            score += 1
        }
    }
    return score
}
}




