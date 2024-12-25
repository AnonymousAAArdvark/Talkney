//
//  CreateAccountView.swift
//  Talkney
//
//  Created by Andrew Yang on 11/7/24.
//

import SwiftUI

struct CreateAccountView: View {
    @Binding var navigationPath: NavigationPath
    @State private var fullName: String = ""
    @State private var contactInput: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var contactMethod: ContactMethod = .email
    @State private var selectedCountryCode: CountryCode = .unitedStates
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case fullName, contact, password
    }
    
    private enum ContactMethod: String, CaseIterable {
        case email = "Email"
        case phone = "Phone"
    }
    
    // Common country codes, can be expanded
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
    private var isPasswordValid: Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
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
        !fullName.isEmpty && isContactValid && isPasswordValid
    }
    
    // MARK: - UI Components
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Welcome! Let's get started.")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
            
            Text("Create a profile to start with the all-in-one platform for learning trending slang and memes.")
                .font(.system(size: 16))
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
                        SecureField(title, text: text)
                            .textContentType(.newPassword)
                    } else if isSecure {
                        TextField(title, text: text)
                            .textContentType(.newPassword)
                    } else {
                        TextField(title, text: text)
                            .textContentType(contentType)
                    }
                }
                .padding()
                .foregroundColor(.white)
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
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
            
            if isSecure {
                Text("Must be at least 8 characters with at least 1 number and 1 special character.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isPasswordValid ? .green : .red)
            }
        }
    }
    
    private var startButton: some View {
        Button(action: {
            let contact = contactMethod == .phone ? "\(selectedCountryCode.rawValue)\(contactInput)" : contactInput
            navigationPath.append(Screen.emailVerification(email: contact))
        }) {
            Text("Start")
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
                            title: "First and last...",
                            text: $fullName,
                            field: .fullName,
                            contentType: .name
                        )
                        
                        customTextField(
                            title: "Enter your password...",
                            text: $password,
                            field: .password,
                            contentType: .newPassword,
                            isSecure: true
                        )
                    }
                    .padding()
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                startButton
            }
        }
        .onTapGesture {
            focusedField = nil
        }
    }
}


// MARK: Custom Button to prevent keyboard from dismissing
struct NonDismissableButton<Content: View>: View {
    var action: () -> Void
    var content: () -> Content
    
    var body: some View {
        Button(action: action) {
            content()
        }
        .buttonStyle(PlainButtonStyle()) // Style to ensure it doesn't affect keyboard dismissal
        .background(NonDismissableInteraction()) // Disable focus interaction
    }
}

struct NonDismissableInteraction: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = true // Allows touch events to be handled
        view.addGestureRecognizer(UITapGestureRecognizer(target: nil, action: nil)) // Disable focus interaction
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - View Extension for Placeholder Styling
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            self
            if shouldShow {
                placeholder()
                    .padding(.leading, 15)
                    .allowsHitTesting(false)
            }
        }
    }
}

// Preview
struct CreateAccountView_Previews: PreviewProvider {
    @State static var navigationPath = NavigationPath()

    static var previews: some View {
        CreateAccountView(navigationPath: $navigationPath)
    }
}
