//
//  RegisterView.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//


import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var vm: AuthViewModel
    @FocusState private var focusedField: Field?

    enum Field { case firstName, lastName, email, confirmEmail, password }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundDark").ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("Get Started")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundColor(Color("AccentColor"))
                        .padding(.top, 60)

                    // MARK: - Input Card
                    VStack(spacing: 16) {
                        // First & Last Name
                        TextField("First Name", text: $vm.firstName)
                            .textContentType(.givenName)
                            .focused($focusedField, equals: .firstName)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("CardDark"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .firstName ? Color("AccentColor") : .clear, lineWidth: 2)
                            )

                        TextField("Last Name", text: $vm.lastName)
                            .textContentType(.familyName)
                            .focused($focusedField, equals: .lastName)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("CardDark"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .lastName ? Color("AccentColor") : .clear, lineWidth: 2)
                            )

                        // Email & Confirm Email
                        TextField("Email Address", text: $vm.email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .email)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("CardDark"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .email ? Color("AccentColor") : .clear, lineWidth: 2)
                            )

                        TextField("Confirm Email", text: $vm.confirmEmail)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .confirmEmail)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("CardDark"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .confirmEmail ? Color("AccentColor") : .clear, lineWidth: 2)
                            )

                        // Password
                        SecureField("Create Password", text: $vm.password)
                            .textContentType(.newPassword)
                            .focused($focusedField, equals: .password)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("CardDark"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .password ? Color("AccentColor") : .clear, lineWidth: 2)
                            )

                        // Error message
                        if let error = vm.errorMessage {
                            Text(error)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                                .transition(.opacity.combined(with: .slide))
                        }

                        // Sign Up Button
                        Button {
                            Task { await vm.register() }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("AccentColor"))
                                if vm.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Sign Up")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 50)
                        }
                        .disabled(vm.isLoading)
                    }
                    .padding(24)
                    .background(Color("CardDark").opacity(0.8))
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                    .padding(.horizontal, 24)

                    // Back to Login
                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account? Log In")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 40)
                }
                .animation(.easeInOut, value: vm.errorMessage)
            }
            .navigationBarHidden(true)
            .onTapGesture { hideKeyboard() }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterView()
                .environmentObject(AuthViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
