//
//  SignupView.swift
//  JoyceAI
//
//  Created by C119142 on 5/24/24.
//

import SwiftUI

struct SignupView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    let interests = ["Sports", "Music", "Travel", "Technology", "Art"]
        @State private var selectedInterests: [String] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Username TextField
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                
                // Email TextField
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                // Password SecureField
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                
                // Confirm Password SecureField
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                
                VStack(alignment: .leading) {
                                       Text("Select your interests:")
                                           .font(.headline)
                                       ForEach(interests, id: \.self) { interest in
                                           Toggle(interest, isOn: Binding<Bool>(
                                               get: {
                                                   selectedInterests.contains(interest)
                                               },
                                               set: { newValue in
                                                   if newValue {
                                                       selectedInterests.append(interest)
                                                   } else {
                                                       selectedInterests.removeAll { $0 == interest }
                                                   }
                                               }
                                           ))
                                           .toggleStyle(CheckboxToggleStyle())
                                       }
                                   }
        
                // Signup Button
                Button(action: {
                    // Validate and handle signup action
                    if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                        alertMessage = "All fields are required."
                        showingAlert = true
                    } else if password != confirmPassword {
                        alertMessage = "Passwords do not match."
                        showingAlert = true
                    } else {
                        // Perform signup action
                        print("Signup button tapped")
                        // Add your signup logic here
                    }
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign Up")
            
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .foregroundColor(configuration.isOn ? .blue : .secondary)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        .padding(.vertical, 4)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
