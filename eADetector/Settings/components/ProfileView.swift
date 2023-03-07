//
//  ProfileView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 2/27/23.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    @State private var firstName = ""
    @State private var lastName = ""
    @EnvironmentObject var authSessionManager: AuthSessionManager
    @Environment(\.presentationMode) var presentation

    @State private var showingAlert = false
    
    init(user: User) {
            self.user = user
            _firstName = State(initialValue: user.firstName)
            _lastName = State(initialValue: user.lastName)
        }
    
    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Last Name", text: $lastName)
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
            if (firstName != user.firstName) {
                await authSessionManager.updateFirstName(firstName: firstName)
            }
            if (lastName != user.lastName) {
                await authSessionManager.updateLastName(lastName: lastName)
            }
            
            if (firstName != user.firstName || lastName != user.lastName) {
                self.presentation.wrappedValue.dismiss()
            } else {
                showingAlert = true
            }
        }
    }
}

