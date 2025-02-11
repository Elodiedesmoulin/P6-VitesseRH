//
//  EditingViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

@MainActor
final class EditingViewModel: ObservableObject {
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
    
    func saveChanges() async {
        errorMessage = nil
        
        guard candidate.email.isValidEmail() else {
            self.errorMessage = "Invalid email format."
            return
        }
        if !candidate.phone.isEmpty && !candidate.phone.isValidFrPhone() {
            self.errorMessage = "Invalid phone number format."
            return
        }
        candidate.phone.applyFrPhonePattern()
        if let linkedinURL = candidate.linkedinURL, !linkedinURL.isEmpty, URL(string: linkedinURL) == nil {
            self.errorMessage = "Invalid LinkedIn URL."
            return
        }
        
        let result = await service.updateCandidate(candidate: candidate)
        await MainActor.run {
            switch result {
            case .success(let updatedCandidate):
                self.candidate = updatedCandidate
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
