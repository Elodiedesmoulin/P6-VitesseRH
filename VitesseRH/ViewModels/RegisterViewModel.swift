//
//  RegisterViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

@MainActor
class RegisterViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var registrationMessage: String? = nil
    @Published var isRegistered: Bool = false
    
    private let service: VitesseRHService
    
    init(service: VitesseRHService = VitesseRHService()) {
        self.service = service
    }
    
    func register() {
        guard !firstName.isEmpty, !lastName.isEmpty else {
            self.registrationMessage = VitesseRHError.invalidName.localizedDescription
            return
        }
        
        guard isEmailValid(email) else {
            self.registrationMessage = VitesseRHError.invalidEmail.localizedDescription
            return
        }
        
        guard isPasswordValid(password) else {
            self.registrationMessage = VitesseRHError.invalidPassword.localizedDescription
            return
        }
        
        guard password == confirmPassword else {
            self.registrationMessage = VitesseRHError.passwordMismatch.localizedDescription
            return
        }
        
        Task {
            do {
                try await service.register(firstName: firstName, lastName: lastName, email: email, password: password)
                DispatchQueue.main.async {
                    self.isRegistered = true
                    self.registrationMessage = "Account created successfully."
                }
            } catch let error as VitesseRHError {
                DispatchQueue.main.async {
                    self.registrationMessage = error.localizedDescription
                }
            } catch let error as URLError {
                if error.code == .notConnectedToInternet {
                    self.registrationMessage = VitesseRHError.networkError.localizedDescription
                } else if error.code == .timedOut {
                    self.registrationMessage = VitesseRHError.timeout.localizedDescription
                } else {
                    self.registrationMessage = VitesseRHError.unknown.localizedDescription
                }
            } catch {
                DispatchQueue.main.async {
                    self.registrationMessage = VitesseRHError.unknown.localizedDescription
                }
            }
        }
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 6
    }
}

