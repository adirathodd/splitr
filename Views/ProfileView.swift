//
//  ProfileView.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//


import SwiftUI
import FirebaseAuth 

struct ProfileView: View {
    @EnvironmentObject private var authVM: AuthViewModel

    private var user: FirebaseAuth.User? {
        AuthService.shared.currentUser()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundDark")
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    if let u = user {
                        Text(u.displayName ?? "No Name")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text(u.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        Text("No user data")
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button("Sign Out") {
                        authVM.signOut()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("AccentColor"))

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 15")
    }
}
