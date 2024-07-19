//
//  LoginView.swift
//  JoyceAI
//
//  Created by C119142 on 5/23/24.
//

import SwiftUI

struct LoginView: View {
    // State variables to hold the user input
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var isLoggedIn = false
    @State private var isSigningUp = false
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Text("Welcome! Get started with Login")
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                // Username TextField
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                
                // Password SecureField
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)

                // Login Button
                Button(action: {
                    // Handle login action here
                    if username.isEmpty || password.isEmpty {
                        showingAlert = true
                    } else {
                        print("Login button tapped")
                        isLoggedIn = true
                        // Add your login logic here
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(5.0)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please enter both username and password."),
                        dismissButton: .default(Text("OK"))
                    )
                }

                Text("or")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(5.0)
                
                Text("Sign up if you're new to Joyce")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(5.0)
                    .underline()
                    .onTapGesture {
                        isSigningUp = true
                    }

                Spacer()

                NavigationLink(destination: ContentView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                NavigationLink(destination: SignupView(), isActive: $isSigningUp ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .background(.black)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Joyce AI")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LoginViewModel()
        LoginView(viewModel: viewModel)
    }
}
