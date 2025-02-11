//
//  RegisterViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var password: String = ""
    @Published var confirmPwd: String = ""
    
    @Published var isRegistered = false
    @Published var inProgress = false
    @Published var errorMessage: VitesseRHError? = nil
    
    func register() {
        guard textfieldsAreValid() else { return }
        inProgress = true
        Task {
            let result = await VitesseRHService().register(mail: email, password: password, firstName: firstName, lastName: lastName)
            await processResult(result)
        }
    }
    
    private func processResult(_ result: Result<Bool, VitesseRHError>) async {
        await MainActor.run {
            switch result {
            case .success:
                self.errorMessage = nil
                self.isRegistered = true
            case .failure(let error):
                self.errorMessage = error
            }
            self.inProgress = false
        }
    }
    
    private func textfieldsAreValid() -> Bool {
        errorMessage = nil
        
        guard !firstName.isEmpty || !lastName.isEmpty else {
            errorMessage = .validation(.invalidName)
            return false
        }
        
        guard !email.isEmpty  else {
            errorMessage = .validation(.emptyEmail)
            return false
        }
        
        guard !password.isEmpty else {
            errorMessage = .validation(.emptyPassword)
            return false
        }
        
//        guard !confirmPwd.isEmpty else {
//            errorMessage = .validation(.passwordMismatch)
//            return false
//        }
        
        guard email.isValidEmail() else {
            errorMessage = .validation(.invalidEmail)
            return false
        }
        guard  password == confirmPwd else {
            errorMessage = .validation(.passwordMismatch)
            return false
        }
        return true
    }
}
