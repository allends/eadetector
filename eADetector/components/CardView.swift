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
    
    var name: String
    var date: String
    
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
                Text(content)
                Button("Take Test"){}
                    .disabled(true)
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                    .background(Color(red: 0, green:0.5, blue: 0))
                    .cornerRadius(10)
                
            }
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 20, trailing: 15))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .animation(Animation.easeInOut(duration: 0.3))
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


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView( content: "The Memory Impairement Screen (MIS) is a brief screening tool to evaluate memory skills in a patient.", name: "Memory Impairment Screen (MIS)", date:"02/21/2020"
        )
    }
}
