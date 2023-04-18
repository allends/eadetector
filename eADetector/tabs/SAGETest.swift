//
//  SAGETest.swift
//  eADetector
//
//  Created by Sidhu Arakkal on 4/17/23.
//

import SwiftUI

// Model for SAGE Question
struct SAGEQuestion: Identifiable {
    let id: Int
    let question: String
    let answers: [String]
    let correctAnswerIndex: Int
    var shuffledAnswers: [String] = []
}

// View for SAGE Test
struct SAGETest: View {
    @State private var questions: [SAGEQuestion] = []
    @State private var selectedAnswers: [Int?] = [nil, nil, nil, nil]
    @State private var score: Int? = nil
    @State private var showAnswers: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(questions) { question in
                    VStack(alignment: .leading) {
                        Text(question.question)
                            .font(.headline)
                        ForEach(0..<question.shuffledAnswers.count, id: \.self) { index in
                            Button(action: {
                                selectedAnswers[question.id] = index
                            }) {
                                HStack {
                                    Image(systemName: selectedAnswers[question.id] == index ? "checkmark.circle.fill" : "circle")
                                    Text(question.shuffledAnswers[index])
                                        .font(.body)
                                }
                            }
                        }
                        if showAnswers {
                            Text("Correct Answer: \(question.answers[question.correctAnswerIndex])")
                                .font(.footnote)
                                .foregroundColor(.green)
                        }
                    }
                }
                Button(action: {
                    verifyAnswer()
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(score != nil)
                if let score = score {
                    Text("Score: \(score)/\(questions.count)")
                        .font(.headline)
                }
            }
            .padding()
            .onAppear {
                generateQuestions()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.95) // Set width to 80% of screen width
    }
    
    // Function to generate questions based on current date
    func generateQuestions() {
        // Get the current date
        let currentDate = Date()

        // Extract the day, month, and year components from the current date
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        let dayOfWeek = calendar.component(.weekday, from: currentDate) - 1 // Subtract 1 to convert to 0-based index

        // Use the day, month, and year components to generate questions
        questions = [
            SAGEQuestion(id: 0, question: "What is the day of the month?", answers: ["\(day)", "\(day + 1)", "\(day - 1)", "\(day + 2)"], correctAnswerIndex: 0),
            SAGEQuestion(id: 1, question: "What is the month?", answers: ["\(month)", "\(month + 1)", "\(month - 1)", "\(month + 2)"], correctAnswerIndex: 0),
            SAGEQuestion(id: 2, question: "What is the year?", answers: ["\(year)", "\(year + 1)", "\(year - 1)", "\(year + 2)"], correctAnswerIndex: 0),
            SAGEQuestion(id: 3, question: "What is the day of the week?", answers: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], correctAnswerIndex: dayOfWeek)
        ]

        // Shuffle the answers for each question
        for i in 0..<questions.count {
            questions[i].shuffledAnswers = questions[i].answers.shuffled()
        }
    }



    
    // Function to verify answers and calculate score
    func verifyAnswer() {
        var totalScore = 0
        for i in 0..<questions.count {
            if let selectedAnswerIndex = selectedAnswers[i],
               questions[i].shuffledAnswers[selectedAnswerIndex] == questions[i].answers[questions[i].correctAnswerIndex] {
                totalScore += 1
            }
        }
        score = totalScore
        showAnswers = true
    }
    
}
