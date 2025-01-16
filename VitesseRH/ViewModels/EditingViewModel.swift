//
//  EditingViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

class EditingViewModel: ObservableObject {
    @Published var candidate: Candidate
    var token: String
    var candidateId: String
    var service: VitesseRHService
    @Published var errorMessage: String? = nil

    init(candidate: Candidate, token: String, candidateId: String, service: VitesseRHService) {
        self.candidate = candidate
        self.token = token
        self.candidateId = candidateId
        self.service = service
    }

    func saveChanges(for candidate: Candidate) {
        guard isValidEmail(candidate.email) else {
            self.errorMessage = VitesseRHError.invalidEmail.userFriendlyMessage()
            return
        }
        
        guard isValidFrenchPhoneNumber(candidate.phone) else {
            self.errorMessage = VitesseRHError.invalidPhone.userFriendlyMessage()
            return
        }

        if let linkedinURL = candidate.linkedinURL, !linkedinURL.isEmpty {
            guard isValidURL(linkedinURL) else {
                self.errorMessage = VitesseRHError.invalidLinkedInURL.userFriendlyMessage()
                return
            }
        }

        Task {
            do {
                try await service.updateCandidate(token: token, candidateId: candidate.id, candidate: candidate)
                DispatchQueue.main.async {
                    self.errorMessage = nil
                }
            } catch let error as VitesseRHError {
                DispatchQueue.main.async {
                    self.errorMessage = error.userFriendlyMessage()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = VitesseRHError.networkError.userFriendlyMessage()
                }
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
    
    func isValidURL(_ urlString: String) -> Bool {
        if let urlComponents = URLComponents(string: urlString),
           urlComponents.scheme != nil,
           urlComponents.host != nil {
            return true
        }
        return false
    }
}
