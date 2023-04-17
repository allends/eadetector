//
//  CardView.swift
//  eADetector
//
//  Created by Sidhu Arakkal on 3/27/23.
//

import SwiftUI

struct CardView: View {
    @State var content: String
    @State private var collapsed: Bool = true
    @State private var showGame = false
    
    var name: String
    var date: String
    var test: String
    
    var body: some View {
        
        VStack {
            Button(
                action: {self.collapsed.toggle()},
                label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(name)
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                            Text("Last Taken: " + date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .layoutPriority(100)
                        Spacer()
                        Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                    }
                    .padding()
                }
            )
            .buttonStyle(PlainButtonStyle())
            
            VStack {
                Text(content + "\n")
                
                if (test == "Reaction") {
                    NavigationLink(destination: ReactionTest()) {
                        Text("Start Test")}
                } else if (test == "MIS") {
                    Text("NOT IMPLEMENTED")
                } else if (test == "SAGE") {
                    Text("NOT IMPLEMENTED")
                }
                
                
            }
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 20, trailing: 15))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .animation(.easeInOut(duration: 0.3))
            .transition(.slide)
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}

