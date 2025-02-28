//
//  EditingViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

@MainActor
final class EditingViewModel: ObservableObject {
    private let service: VitesseRHServiceProtocol

    @Published var candidate: Candidate
    var token: String
    var candidateId: String
    @Published var errorMessage: String? = nil
    
    init(candidate: Candidate, token: String, candidateId: String, service: VitesseRHServiceProtocol = VitesseRHService()) {
        self.candidate = candidate
        self.token = token
        self.candidateId = candidateId
        self.service = service
    }
    
    func saveChanges() async {
        errorMessage = nil
        
        guard candidate.email.isValidEmail() else {
            self.errorMessage = VitesseRHError.validation(.invalidEmail).localizedDescription
            return
        }
        if !candidate.phone.isEmpty && !candidate.phone.isValidFrPhone() {
            self.errorMessage = VitesseRHError.validation(.invalidPhone).localizedDescription
            return
        }
        if let linkedinURL = candidate.linkedinURL, !linkedinURL.isEmpty, URL(string: linkedinURL)?.scheme == nil {
            self.errorMessage = VitesseRHError.validation(.invalidLinkedInURL).localizedDescription
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
