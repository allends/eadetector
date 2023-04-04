//
//  ProfileView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 2/27/23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @State private var first: String
    @State private var last: String
    
    
    init(first: String, last: String) {
        self.first = first
        self.last = last
    }

    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            TextField("First Name", text: $first)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Last Name", text: $last)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: saveChanges) {
                Text("Save Changes")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding().alert("Please update your information to submit changed", isPresented: $showingAlert) {
                Button("Alrighty", role: .cancel) { }
            }
        }
    }
    
    func saveChanges() {
        Task {
            await authSessionManager.updateName(first:first, last:last)
        }
    }
}

