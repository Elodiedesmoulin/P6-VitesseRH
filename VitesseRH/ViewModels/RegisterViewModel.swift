//
//  RegisterViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var isRegistered = false
    @Published var inProgress = false
    @Published var errorMessage: VitesseRHError?
    
    private let service: VitesseRHServiceProtocol
    
    init(service: VitesseRHServiceProtocol = VitesseRHService()) {
        self.service = service
    }
    
    func register() {
        guard areTextFieldsValid() else { return }
        inProgress = true
        Task {
            let result = await service.register(mail: email, password: password, firstName: firstName, lastName: lastName)
            await handleResult(result)
        }
    }
    
    private func handleResult(_ result: Result<Bool, VitesseRHError>) async {
        await MainActor.run {
            switch result {
            case .success:
                errorMessage = nil
                isRegistered = true
            case .failure(let error):
                errorMessage = error
            }
            inProgress = false
        }
    }
    
    private func areTextFieldsValid() -> Bool {
        if firstName.isEmpty || lastName.isEmpty {
            errorMessage = .validation(.invalidName)
            return false
        }
        if email.isEmpty {
            errorMessage = .validation(.emptyEmail)
            return false
        }
        if password.isEmpty {
            errorMessage = .validation(.emptyPassword)
            return false
        }
        if !email.isValidEmail() {
            errorMessage = .validation(.invalidEmail)
            return false
        }
        if password != confirmPassword {
            errorMessage = .validation(.passwordMismatch)
            return false
        }
        return true
    }
}
