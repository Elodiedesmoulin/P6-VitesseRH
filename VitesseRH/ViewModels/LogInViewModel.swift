//
//  LogInViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = "admin@vitesse.com"
    @Published var password = "test123"
    @Published var token: String?
    @Published var isAuthenticated = false
    @Published var loginMessage: String?
    
    private let service = VitesseRHService()
    
    func login() {
        guard isEmailValid(email) else {
            loginMessage = "Veuillez entrer une adresse e-mail valide."
            return
        }
        
        guard isPasswordValid(password) else {
            loginMessage = "Le mot de passe doit contenir au moins 6 caractères."
            return
        }
        
        Task {
            do {
                token = try await service.login(email: email, password: password)
                isAuthenticated = true
                loginMessage = nil
            } catch {
                isAuthenticated = false
                loginMessage = "Erreur de connexion. Veuillez vérifier vos identifiants."
            }
        }
    }
    
    func logout() {
        isAuthenticated = false
        token = nil
        email = ""
        password = ""
        loginMessage = nil
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 6
    }
}
