//
//  RegisterViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

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
            self.registrationMessage = "Veuillez remplir tous les champs."
            return
        }
        
        guard isEmailValid(email) else {
            self.registrationMessage = "Veuillez entrer une adresse e-mail valide."
            return
        }
        
        guard isPasswordValid(password) else {
            self.registrationMessage = "Le mot de passe doit contenir au moins 6 caractères."
            return
        }
        
        guard password == confirmPassword else {
            self.registrationMessage = "Les mots de passe ne correspondent pas."
            return
        }
        
        
        Task {
            do {
                try await service.register(firstName: firstName, lastName: lastName, email: email, password: password)
                DispatchQueue.main.async {
                    self.isRegistered = true
                    self.registrationMessage = "Compte créé avec succès."
                }
            } catch {
                DispatchQueue.main.async {
                    self.registrationMessage = "Erreur lors de l'inscription. Veuillez réessayer."
                    print(error.localizedDescription)
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

