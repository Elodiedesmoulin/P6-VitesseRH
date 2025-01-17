//
//  CreateCandidateListView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

@MainActor
class CreateCandidateViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var creatingMessage: String?
    
    private let service: VitesseRHService
    private var token: String
    
    init(service: VitesseRHService = VitesseRHService(), token: String) {
        self.service = service
        self.token = token
    }
    
    
    
    private func handleSuccess() {
        self.errorMessage = nil
        self.creatingMessage = "Candidate created successfully."
    }
    
    private func handleError(error: VitesseRHError) {
        self.errorMessage = error.localizedDescription
    }
    
    
    
    func addCandidate(candidate: Candidate) {
        guard isValidEmail(candidate.email) else {
            self.errorMessage = VitesseRHError.invalidEmail.localizedDescription
            return
        }
        
        guard isValidFrenchPhoneNumber(candidate.phone) else {
            self.errorMessage = VitesseRHError.invalidPhone.localizedDescription
            return
        }
        
        guard isNameValid(candidate.firstName, candidate.lastName) else {
            self.errorMessage = VitesseRHError.invalidName.localizedDescription
            return
        }

        Task {
            do {
                try await service.createCandidate(token: token, candidate: candidate)
                self.handleSuccess()
            } catch let error as VitesseRHError {
                self.handleError(error: error)
            } catch {
                self.handleError(error: VitesseRHError.networkError)
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidFrenchPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^((\\+33|0)[1-9])((\\s|\\-)?[0-9]{2}){4}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    private func isNameValid(_ firstName: String, _ lastName: String) -> Bool {
        return firstName.count >= 3 && lastName.count >= 3
    }
}
