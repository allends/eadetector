//
//  ReactionTest.swift
//  eADetector
//
//  Created by Sidhu Arakkal on 4/17/23.
//

import SwiftUI

struct ReactionTest: View {
    @State private var isScreenGreen = false
    @State private var isGameStarted = false
    @State private var startTime = DispatchTime.now()
    @State private var endTime = DispatchTime.now()
    @State private var reactionTimes: [Double] = []
    @State private var rounds = 0

    var body: some View {
        VStack {
            Text("Average Reaction Time: \(getAverageReactionTime()) ms")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 75)
            
            
            if isGameStarted {
                Text("Round \(rounds)")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                
                Text("Reaction Time: \(getCurrentReactionTime()) ms")
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .padding()
                
                if isScreenGreen {
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            endRound()
                        }
                } else {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                }
                
                Spacer()
            } else {
                Text("Instructions")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .padding()
                
                Text("There will be a white square displayed on the screen. Whenever it turns green, click it! Tap 'Start' when you are ready to begin.")
                    .multilineTextAlignment(.leading)
                    .font(.title)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 25, trailing: 5))
                
                Button(action: {
                    resetGame()
                }) {
                    Text("Start")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(7)
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func startRound() {
        isScreenGreen = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int.random(in: 1000...3000))) {
            self.startTime = DispatchTime.now()
            self.isScreenGreen = true
        }
    }

    func endRound() {
        if isScreenGreen {
            endTime = DispatchTime.now()
            let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
            let reactionTime = Double(nanoTime) / 1_000_000 // Convert to milliseconds
            reactionTimes.append(reactionTime)
            rounds += 1
            isScreenGreen = false
            if rounds < 10 {
                startRound()
            } else {
                // Game Over
                isGameStarted = false
            }
        }
    }

    func getAverageReactionTime() -> Double {
        if reactionTimes.isEmpty {
            return 0
        } else {
            let totalReactionTime = reactionTimes.reduce(0, +)
            return totalReactionTime / Double(reactionTimes.count)
        }
    }
    
    func getCurrentReactionTime() -> Double {
        if rounds > 0 && rounds <= reactionTimes.count {
            return reactionTimes[rounds - 1]
        } else {
            return 0
        }
    }
    
    func resetGame() {
        isGameStarted = true
        startTime = DispatchTime.now()
        endTime = DispatchTime.now()
        reactionTimes.removeAll()
        rounds = 0
        startRound()
    }
}
