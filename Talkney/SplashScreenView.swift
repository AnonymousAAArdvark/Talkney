//
//  SplashScreenView.swift
//  Talkney
//
//  Created by Andrew Yang on 11/6/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var path: NavigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                ZStack {
                    Color.black
                        .ignoresSafeArea() // Background color
                    
                    VStack {
                        
                        // Top Image Section
                        Image("Splash Image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: geometry.size.height * 0.4) // Scale top image based on screen height
                            .padding(.top, geometry.size.height * 0.03) // Relative top padding
                        
                        // Description Text
                        Text("Millions of slangs.\nLearn on Talkney.")
                            .font(.system(size: geometry.size.width * 0.08, weight: .bold)) // Relative font size
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, geometry.size.height * 0.02)
                        
                        Spacer()
                        
                        VStack(spacing: 15) {
                            // Create Account Button
                            NavigationLink(value: Screen.createAccount) {
                                Text("Create account")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("Primary Theme"))
                                    .foregroundColor(.white)
                                    .cornerRadius(25)
                            }
                            .padding(.horizontal, 20)
                            
                            // Google Sign-In Button
                            Button(action: {
                                // Handle Google sign-in action
                            }) {
                                HStack {
                                    Image("Google Logo")
                                        .resizable()
                                        .frame(width: 20, height: 20) // Fixed size for logo
                                    Text("Continue with Google")
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .foregroundColor(.white)
                            }
                            .padding(.horizontal, 20)
                            
                            // Apple Sign-In Button
                            Button(action: {
                                // Handle Apple sign-in action
                            }) {
                                HStack {
                                    Image(systemName: "applelogo")
                                        .resizable()
                                        .frame(width: 20, height: 20) // Fixed size for logo
                                    Text("Continue with Apple")
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .foregroundColor(.white)
                            }
                            .padding(.horizontal, 20)
                            
                            // Sign-In Link
                            NavigationLink(value: Screen.signIn) {
                                Text("Sign in your account")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.bottom, geometry.safeAreaInsets.bottom)
                    }
                }
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .createAccount:
                    CreateAccountView(navigationPath: $path)
                case .signIn:
                    SignInView(navigationPath: $path)
                case .emailVerification(let email):
                    EmailVerificationView(navigationPath: $path, email: email)
                case .home:
                    HomeView()
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
