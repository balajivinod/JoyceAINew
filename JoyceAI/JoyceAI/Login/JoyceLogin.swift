//
//  JoyceLogin.swift
//  JoyceAI
//
//  Created by C119142 on 5/25/24.
//
import AuthenticationServices
import SwiftUI

private enum Constants {
    static let backgroundColor = Color("background")
}

struct JoyceLogin: View {
    @State var isLoggedIn = false
    @State var showLoginOptions = false
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.backgroundColor
                                .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 158, height: 172)
                        .padding()
                    Text("JOYCE AI")
                        .foregroundColor(.white)
                        .appFont(.montserrat, weight: .medium, size: 20.0, relativeTo: .body)
                    Spacer()
                    Spacer()
                }
        
                LoginOptionsView(showLoginOptions: $showLoginOptions,
                                 isLoggedIn: $isLoggedIn)
                .navigationDestination(isPresented: $isLoggedIn) {
                    ContentView()
                }
            }
            .onAppear() {
                showLoginOptions = true
            }
            .background(Constants.backgroundColor)
        }
    }
}

struct LoginOptionsView: View {
    @Binding var showLoginOptions: Bool
    @Binding var isLoggedIn: Bool
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack {
                    Button(action: {
                        // Handle login with Email
                        self.showLoginOptions = false
                        performSignInWithApple()
                        
                    }) {
                        Text("Continue with Apple")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(15)
                            .appFont(.montserrat, weight: .bold, size: 18.0, relativeTo: .body)
                    }
                    .padding([.leading, .trailing])
        
                    Button(action: {
                        // Handle login with Google
                        self.showLoginOptions = false
                    }) {
                        Text("Continue with Google")
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                            .padding()
                            .background(Color(red: 0.173, green: 0.173, blue: 0.181))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .appFont(.montserrat, weight: .bold, size: 18.0, relativeTo: .body)
                    }
                    .padding([.leading, .trailing])
                    
                    Button(action: {
                        // Handle login with Facebook
                        self.showLoginOptions = false
                    }) {
                        Text("Sign up with email")
                            .padding()
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.173, green: 0.173, blue: 0.181))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .appFont(.montserrat, weight: .bold, size: 18.0, relativeTo: .body)
                    }
                    .padding([.leading, .trailing])
                    
                    Button(action: {
                        self.showLoginOptions = false
                        isLoggedIn = true
                    }) {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 0.173, green: 0.173, blue: 0.181))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .appFont(.montserrat, weight: .bold, size: 18.0, relativeTo: .body)
                    }
                    .padding([.leading, .trailing])
                    
                    Button(action: {
                        self.showLoginOptions = false
                    }) {
                        Text("")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .appFont(.montserrat, weight: .bold, size: 16.0, relativeTo: .body)
                    }
                }
//                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(Color.black)
                .cornerRadius(20)
                .shadow(radius: 20)
//                .padding( .trailing, 20)
            }
            .frame(maxWidth: .infinity)
//            .padding()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

extension LoginOptionsView {
    func performSignInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = SignInWithAppleDelegate()
        authorizationController.performRequests()
    }
}

class SignInWithAppleDelegate: NSObject, ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Handle user information and perform any necessary sign-in logic
            print("User ID: \(userIdentifier)")
            print("User Name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
            print("User Email: \(email ?? "")")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
        print("Sign in with Apple errored: \(error.localizedDescription)")
    }
}

#Preview {
    JoyceLogin()
}
