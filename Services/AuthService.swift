//
//  AuthService.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//



import Foundation
import FirebaseAuth

/// Errors specific to our auth flow.
enum AuthError: LocalizedError {
    case unknown

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "An unknown authentication error occurred."
        }
    }
}

/// Singleton service that handles registration, login, user state, and profile updates.
final class AuthService: ObservableObject {
    static let shared = AuthService()

    /// The currently signed-in Firebase user (or `nil` if signed out).
    @Published private(set) var user: User?

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    private init() {
        // Initialize current user
        self.user = Auth.auth().currentUser

        // Listen for auth state changes
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            self?.user = firebaseUser
        }
    }

    deinit {
        // Clean up listener
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Authentication Methods

    /// Registers a new user with email & password.
    /// - Returns: The newly created Firebase `User`.
    func register(email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<User, Error>) in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let firebaseUser = result?.user {
                    continuation.resume(returning: firebaseUser)
                } else {
                    continuation.resume(throwing: AuthError.unknown)
                }
            }
        }
    }

    /// Signs in an existing user with email & password.
    /// - Returns: The signed-in Firebase `User`.
    func login(email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<User, Error>) in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let firebaseUser = result?.user {
                    continuation.resume(returning: firebaseUser)
                } else {
                    continuation.resume(throwing: AuthError.unknown)
                }
            }
        }
    }

    /// Signs out the current user.
    func signOut() throws {
        try Auth.auth().signOut()
        user = nil
    }

    /// Returns the current user, if any.
    func currentUser() -> User? {
        Auth.auth().currentUser
    }
}

// MARK: - Profile Update Extension

extension AuthService {
    /// Updates the Firebase user's display name (e.g., "First Last").
    /// - Parameter name: The full name to set as the user's displayName.
    func updateDisplayName(_ name: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.unknown
        }
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let request = user.createProfileChangeRequest()
            request.displayName = name
            request.commitChanges { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
