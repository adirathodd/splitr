//
//  LoginView.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var vm: AuthViewModel
    @FocusState private var focusedField: Field?
    enum Field { case email, password }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundDark").ignoresSafeArea()

                VStack(spacing: 32) {
                    Text("splitr")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(Color("AccentColor"))
                        .padding(.top, 60)

                    VStack(spacing: 16) {
                        TextField("Email", text: $vm.email)
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

                        SecureField("Password", text: $vm.password)
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("CardDark"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .password ? Color("AccentColor") : .clear, lineWidth: 2)
                            )

                        if let error = vm.errorMessage {
                            Text(error)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                                .transition(.opacity.combined(with: .slide))
                        }

                        Button {
                            Task { await vm.login() }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("AccentColor"))
                                if vm.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Log In")
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

                    HStack {
                        Text("New here?")
                            .foregroundColor(.gray)
                        NavigationLink(destination: RegisterView()) {
                            Text("Create Account")
                                .foregroundColor(Color("AccentColor"))
                                .fontWeight(.bold)
                        }
                    }
                    .font(.footnote)
                    .padding(.bottom, 40)
                }
                .animation(.easeInOut, value: vm.errorMessage)
            }
            .navigationBarHidden(true)
            .onTapGesture { hideKeyboard() }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
                .environmentObject(AuthViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
