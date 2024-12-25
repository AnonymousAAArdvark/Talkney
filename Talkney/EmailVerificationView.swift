//
//  EmailVerificationView.swift
//  Talkney
//
//  Created by Andrew Yang on 11/8/24.
//


import SwiftUI

struct EmailVerificationView: View {
    @Binding var navigationPath: NavigationPath
    let email: String
    
    @State private var verificationCode: String = ""
    @State private var showErrorMessage: Bool = false

    // Simulated validation for a 6-digit code
    var isCodeCorrect: Bool {
        verificationCode.count == 6 && verificationCode.allSatisfy(\.isNumber)
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea() // Background color
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Information Text
                        Text("Verify Your Email")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Enter the 6-digit verification code sent to your email.")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        
                        // Verification Code Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Verification Code")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            TextField("", text: $verificationCode)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color("Text Field Background"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .onChange(of: verificationCode) {
                                    // Only allow numeric input, up to 6 characters
                                    if verificationCode.count > 6 || !verificationCode.allSatisfy(\.isNumber) {
                                        verificationCode = String(verificationCode.prefix(6).filter(\.isNumber))
                                    }
                                }
                                .placeholder(when: verificationCode.isEmpty) {
                                    Text("Enter verification code...")
                                        .foregroundColor(Color("Placeholder Input Text"))
                                }
                        }
                        
                        // Error Message
                        if showErrorMessage {
                            Text("Invalid code. Please try again.")
                                .foregroundColor(.red)
                                .font(.system(size: 16))
                                .padding(.top, 10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)

                Spacer()
                
                // Resend Code Link at the Bottom
                Button(action: {
                    // Handle resend code action
                }) {
                    Text("Resend Code")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Verify Button at the Bottom
                Button(action: {
                    if isCodeCorrect {
                        // Code is correct; handle verification success
                        showErrorMessage = false
                        navigationPath = NavigationPath()
                        navigationPath.append(Screen.home)
                    } else {
                        // Show an error if the code is incorrect
                        showErrorMessage = true
                    }
                }) {
                    Text("Verify")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isCodeCorrect ? Color("Primary Theme") : Color.clear)
                        .foregroundColor(.white)
                        .overlay(
                            isCodeCorrect ? nil :
                                RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .cornerRadius(25)
                }
                .disabled(!isCodeCorrect)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
    }
}

//struct EmailVerificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmailVerificationView()
//    }
//}
