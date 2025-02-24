//
//  LogInViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

final class LoginViewModel: ObservableObject {
    private let authService: AuthenticationServiceProtocol
    private let onLoginSuccess: () -> Void
    
    @Published var email: String = "admin@vitesse.com"
    @Published var password: String = "test123"
    @Published var inProgress = false
    @Published var errorMessage = ""
    
    init(authService: AuthenticationServiceProtocol,
         onLoginSuccess: @escaping () -> Void) {
        self.authService = authService
        self.onLoginSuccess = onLoginSuccess
    }
    
    func signIn() {
        guard areTextFieldsValid() else { return }
        inProgress = true
        Task {
            let result = await authService.logIn(withEmail: email, andPassword: password)
            await handleResult(result)
        }
    }
    
    private func handleResult(_ result: Result<AuthenticationResponse, VitesseRHError>) async {
        await MainActor.run {
            switch result {
            case .success(let authResponse):
                AuthenticationManager.shared.saveAuthData(authResponse)
                onLoginSuccess()
            case .failure(let error):
                errorMessage = error.localizedDescription
                inProgress = false
            }
        }
    }
    
    private func areTextFieldsValid() -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            errorMessage = VitesseRHError.validation(.emptyEmail).localizedDescription
            return false
        }
        if trimmedPassword.isEmpty {
            errorMessage = VitesseRHError.validation(.emptyPassword).localizedDescription
            return false
        }
        if !trimmedEmail.isValidEmail() {
            errorMessage = VitesseRHError.validation(.invalidEmail).localizedDescription
            return false
        }
        if trimmedPassword.count < 6 {
            errorMessage = VitesseRHError.validation(.invalidPassword).localizedDescription
            return false
        }
        return true
    }
}
