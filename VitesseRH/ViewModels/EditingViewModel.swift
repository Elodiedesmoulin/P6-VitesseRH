//
//  EditingViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation
import SwiftUI

@MainActor
final class EditingViewModel: ObservableObject {
    private let service: VitesseRHServiceProtocol

    @Binding var candidate: Candidate
    let token: String
    let candidateId: String
    @Published var errorMessage: String? = nil

    init(candidate: Binding<Candidate>, token: String, candidateId: String, service: VitesseRHServiceProtocol = VitesseRHService()) {
        self._candidate = candidate
        self.token = token
        self.candidateId = candidateId
        self.service = service
    }
    
    func saveChanges() async {
        errorMessage = nil
        
        guard $candidate.wrappedValue.email.isValidEmail() else {
            self.errorMessage = VitesseRHError.validation(.invalidEmail).localizedDescription
            return
        }
        if !$candidate.wrappedValue.phone.isEmpty && !$candidate.wrappedValue.phone.isValidFrPhone() {
            self.errorMessage = VitesseRHError.validation(.invalidPhone).localizedDescription
            return
        }
        if let linkedinURL = $candidate.wrappedValue.linkedinURL, !linkedinURL.isEmpty, URL(string: linkedinURL)?.scheme == nil {
            self.errorMessage = VitesseRHError.validation(.invalidLinkedInURL).localizedDescription
            return
        }
        
        let result = await service.updateCandidate(candidate: $candidate.wrappedValue)
        await MainActor.run {
            switch result {
            case .success(let updatedCandidate):
                self.$candidate.wrappedValue = updatedCandidate
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
