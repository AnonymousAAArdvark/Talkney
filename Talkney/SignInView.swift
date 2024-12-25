//
//  SignInView.swift
//  Talkney
//
//  Created by Andrew Yang on 11/8/24.
//

import SwiftUI

struct SignInView: View {
    @Binding var navigationPath: NavigationPath
    @State private var contactInput: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var contactMethod: ContactMethod = .email
    @State private var selectedCountryCode: CountryCode = .unitedStates
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case contact, password
    }
    
    private enum ContactMethod: String, CaseIterable {
        case email = "Email"
        case phone = "Phone"
    }
    
    private enum CountryCode: String, CaseIterable {
        case unitedStates = "US_1"
        case canada = "CA_1"
        case unitedKingdom = "UK_44"
        case australia = "AU_61"
        case china = "CN_86"
        case japan = "JP_81"
        case southKorea = "KR_82"
        case india = "IN_91"
        
        var flag: String {
            switch self {
            case .unitedStates: return "🇺🇸"
            case .canada: return "🇨🇦"
            case .unitedKingdom: return "🇬🇧"
            case .australia: return "🇦🇺"
            case .china: return "🇨🇳"
            case .japan: return "🇯🇵"
            case .southKorea: return "🇰🇷"
            case .india: return "🇮🇳"
            }
        }
        
        var phoneCode: String {
            switch self {
            case .unitedStates, .canada: return "+1"
            case .unitedKingdom: return "+44"
            case .australia: return "+61"
            case .china: return "+86"
            case .japan: return "+81"
            case .southKorea: return "+82"
            case .india: return "+91"
            }
        }
        
        var display: String {
            "\(flag) \(phoneCode)"
        }
    }
    
    // MARK: - Validation Logic
    private var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: contactInput)
    }
    
    private var isPhoneValid: Bool {
        let phoneRegex = "^\\d{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: contactInput.filter { $0.isNumber })
    }
    
    private var isContactValid: Bool {
        switch contactMethod {
        case .email:
            return isEmailValid
        case .phone:
            return isPhoneValid
        }
    }
    
    private var isFormValid: Bool {
        isContactValid && !password.isEmpty
    }
    
    // MARK: - UI Components
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Welcome Back!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("Enter your email or phone number & password to sign in to Talkney.")
                .font(.system(size: 18))
                .foregroundColor(.gray)
        }
    }
    
    private var contactMethodPicker: some View {
        Picker("Contact Method", selection: $contactMethod) {
            ForEach(ContactMethod.allCases, id: \.self) { method in
                Text(method.rawValue)
                    .foregroundColor(.white)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: contactMethod) { oldValue, newValue in
            contactInput = ""
            if focusedField == .contact {
                // Re-focus to trigger keyboard change
                focusedField = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focusedField = .contact
                }
            }
        }
    }
    
    private func formLabel(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.white)
            .font(.headline)
    }
    
    private var phoneNumberField: some View {
        HStack(spacing: 8) {
            // Country Code Menu
            Menu {
                ForEach(CountryCode.allCases, id: \.self) { code in
                    Button(action: { selectedCountryCode = code }) {
                        Text(code.display)
                    }
                }
            } label: {
                Text(selectedCountryCode.display)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .background(Color("Text Field Background"))
                    .cornerRadius(10)
            }
            
            TextField("Enter your phone number...", text: $contactInput)
                .padding()
                .foregroundColor(.white)
                .keyboardType(.numberPad)
                .textContentType(.telephoneNumber)
                .focused($focusedField, equals: .contact)
                .background(Color("Text Field Background"))
                .cornerRadius(10)
        }
    }
    
    private var emailField: some View {
        TextField("Enter your email...", text: $contactInput)
            .padding()
            .foregroundColor(.white)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            .focused($focusedField, equals: .contact)
            .background(Color("Text Field Background"))
            .cornerRadius(10)
    }
    
    private var contactField: some View {
        VStack(alignment: .leading, spacing: 8) {
            formLabel(contactMethod == .email ? "Email" : "Phone Number")
            
            if contactMethod == .email {
                emailField
            } else {
                phoneNumberField
            }
            
            if !contactInput.isEmpty {
                Text(contactMethod == .email ?
                     "Enter a valid email address" :
                     "Enter a 10-digit phone number")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isContactValid ? .green : .red)
            }
        }
    }
    
    private func customTextField(
        title: String,
        text: Binding<String>,
        field: Field,
        contentType: UITextContentType,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            formLabel(title)
            
            ZStack {
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField("Enter your \(title.lowercased())...", text: text)
                    } else {
                        TextField("Enter your \(title.lowercased())...", text: text)
                    }
                }
                .padding()
                .foregroundColor(.white)
                .keyboardType(keyboardType)
                .textContentType(contentType)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .focused($focusedField, equals: field)
                
                if isSecure {
                    HStack {
                        Spacer()
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.white)
                            .padding(.trailing, 15)
                            .onTapGesture {
                                isPasswordVisible.toggle()
                            }
                    }
                }
            }
            .background(Color("Text Field Background"))
            .cornerRadius(10)
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = field
            }
        }
    }
    
    private var signInButton: some View {
        Button(action: {
            let contact = contactMethod == .phone ? "\(selectedCountryCode.rawValue)\(contactInput)" : contactInput
            navigationPath = NavigationPath([Screen.home])
        }) {
            Text("Sign In")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFormValid ? Color("Primary Theme") : Color.clear)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white, lineWidth: 1)
                )
                .cornerRadius(25)
        }
        .disabled(!isFormValid)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerSection
                        
                        contactMethodPicker
                        contactField
                        
                        customTextField(
                            title: "Password",
                            text: $password,
                            field: .password,
                            contentType: .password,
                            isSecure: true
                        )
                    }
                    .padding()
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                signInButton
            }
        }
        .onTapGesture {
            focusedField = nil
        }
    }
}

// MARK: - Preview
struct SignInView_Previews: PreviewProvider {
    @State static var navigationPath = NavigationPath()
    
    static var previews: some View {
        SignInView(navigationPath: $navigationPath)
    }
}
