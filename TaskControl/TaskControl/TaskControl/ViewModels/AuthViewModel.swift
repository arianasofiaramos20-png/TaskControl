//
//  AuthViewModel.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false

    @Published var isAuthenticated: Bool = false

    private let firebaseService = FirebaseService.shared

    init() {
        isAuthenticated = firebaseService.isUserAuthenticated
    }

    // MARK: - Iniciar sesión

    func login() async {

        guard validateLoginFields() else {
            return
        }

        isLoading = true
        errorMessage = ""
        showError = false

        do {
            try await firebaseService.login(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )

            isAuthenticated = true
            clearFields()

        } catch {
            handleError(error)
        }

        isLoading = false
    }

    // MARK: - Registrar usuario

    func register() async {

        guard validateRegisterFields() else {
            return
        }

        isLoading = true
        errorMessage = ""
        showError = false

        do {
            try await firebaseService.register(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )

            isAuthenticated = true
            clearFields()

        } catch {
            handleError(error)
        }

        isLoading = false
    }

    // MARK: - Cerrar sesión

    func logout() {

        do {
            try firebaseService.logout()
            isAuthenticated = false
            clearFields()

        } catch {
            handleError(error)
        }
    }

    // MARK: - Validaciones

    private func validateLoginFields() -> Bool {

        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanEmail.isEmpty else {
            showValidationError("Ingresa tu correo electrónico.")
            return false
        }

        guard isValidEmail(cleanEmail) else {
            showValidationError("Ingresa un correo electrónico válido.")
            return false
        }

        guard !password.isEmpty else {
            showValidationError("Ingresa tu contraseña.")
            return false
        }

        return true
    }

    private func validateRegisterFields() -> Bool {

        guard validateLoginFields() else {
            return false
        }

        guard password.count >= 6 else {
            showValidationError(
                "La contraseña debe tener al menos 6 caracteres."
            )
            return false
        }

        guard password == confirmPassword else {
            showValidationError("Las contraseñas no coinciden.")
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {

        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#

        return email.range(
            of: pattern,
            options: [.regularExpression, .caseInsensitive]
        ) != nil
    }

    // MARK: - Errores

    private func showValidationError(_ message: String) {
        errorMessage = message
        showError = true
    }

    private func handleError(_ error: Error) {

        if let authError = error as NSError? {

            switch AuthErrorCode(rawValue: authError.code) {

            case .invalidEmail:
                errorMessage = "El correo electrónico no es válido."

            case .emailAlreadyInUse:
                errorMessage = "Este correo ya está registrado."

            case .weakPassword:
                errorMessage = "La contraseña es demasiado débil."

            case .wrongPassword:
                errorMessage = "La contraseña es incorrecta."

            case .userNotFound:
                errorMessage = "No existe una cuenta con este correo."

            case .networkError:
                errorMessage = "No se pudo conectar a internet."

            default:
                errorMessage = error.localizedDescription
            }

        } else {
            errorMessage = error.localizedDescription
        }

        showError = true
    }

    // MARK: - Limpiar campos

    func clearFields() {
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = ""
        showError = false
    }
}
