//
//  LogInViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

final class LoginViewModel: ObservableObject {
    private let onLoginSucceed: () -> Void
    @Published var email: String = "admin@vitesse.com"
    @Published var password: String = "test123"
    @Published var inProgress = false
    @Published var errorMessage = ""
    
    init(onLoginSucceed: @escaping () -> Void) {
        self.onLoginSucceed = onLoginSucceed
    }
    
    func signIn() {
        guard textfieldsAreValid() else { return }
        inProgress = true
        Task {
            let result = await VitesseRHService().logIn(withEmail: email, andPassword: password)
            await processResult(result)
        }
    }
    
    private func processResult(_ result: Result<AuthenticationResponse, VitesseRHError>) async {
        await MainActor.run {
            switch result {
            case .success(let authResponse):
                AuthenticationManager.shared.saveAuthData(authResponse)
                onLoginSucceed()
            case .failure(let error):
                errorMessage = error.localizedDescription
                inProgress = false
            }
        }
    }
    
    private func textfieldsAreValid() -> Bool {
        errorMessage = ""
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty else {
            errorMessage = VitesseRHError.validation(.emptyEmail).localizedDescription
            return false
        }
        guard !trimmedPassword.isEmpty else {
            errorMessage = VitesseRHError.validation(.emptyPassword).localizedDescription
            return false
        }
        guard trimmedEmail.isValidEmail() else {
            errorMessage = VitesseRHError.validation(.invalidEmail).localizedDescription
            return false
        }
        guard trimmedPassword.count >= 6 else {
            errorMessage = VitesseRHError.validation(.invalidPassword).localizedDescription
            return false
        }
        return true
    }
}


