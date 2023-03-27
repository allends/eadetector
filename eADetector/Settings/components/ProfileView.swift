//
//  ProfileView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 2/27/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var name = ""
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @Environment(\.presentationMode) var presentation

    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            TextField("First Name", text: $name)
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
            await authSessionManager.updateFirstName(firstName: name)
        }
    }
}

