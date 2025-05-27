//
//  AuthViewModel.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//



import Foundation
import Combine
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    // MARK: - Input fields
    @Published var firstName:    String = ""
    @Published var lastName:     String = ""
    @Published var email:        String = ""
    @Published var confirmEmail: String = ""
    @Published var password:     String = ""

    // MARK: - Output state
    @Published var isLoading:       Bool   = false
    @Published var errorMessage:    String?
    @Published var isAuthenticated: Bool   = false

    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Set initial authenticated state
        isAuthenticated = authService.currentUser() != nil

        // Observe FirebaseAuth state changes
        authService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.isAuthenticated = (user != nil)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods

    /// Attempts to sign in using email & password.
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            _ = try await authService.login(email: email, password: password)
        } catch {
            handleAuthError(error)
        }

        isLoading = false
    }

    /// Attempts to register a new user with validation.
    func register() async {
        // Validate names
        guard !firstName.isEmpty, !lastName.isEmpty else {
            errorMessage = "Please enter your first and last name."
            return
        }
        // Validate emails & password
        guard !email.isEmpty, !confirmEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill out all fields."
            return
        }
        guard email == confirmEmail else {
            errorMessage = "Email addresses do not match."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            _ = try await authService.register(email: email, password: password)
            let fullName = "\(firstName) \(lastName)"
            try await authService.updateDisplayName(fullName)
        } catch {
            handleAuthError(error)
        }

        isLoading = false
    }

    /// Signs out the current user.
    func signOut() {
        do {
            try authService.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Helper

    /// Parses FirebaseAuth errors into user-friendly messages.
    private func handleAuthError(_ error: Error) {
        let nsError = error as NSError
        if let code = AuthErrorCode(rawValue: nsError.code) {
            switch code {
            case .invalidEmail:
                errorMessage = "That email address is malformed."
            case .weakPassword:
                errorMessage = "Password is too weak (min 6 characters)."
            case .emailAlreadyInUse:
                errorMessage = "That email is already registered."
            case .networkError:
                errorMessage = "Network error. Check your connection."
            case .wrongPassword:
                errorMessage = "Incorrect password."
            case .userDisabled:
                errorMessage = "This account has been disabled."
            default:
                errorMessage = nsError.localizedDescription
            }
        } else {
            errorMessage = nsError.localizedDescription
        }
    }
}
