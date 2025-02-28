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
    @Published var errorMessage: String?
    var token: String
    var candidateId: String

    init(candidate: Binding<Candidate>, token: String, candidateId: String, service: VitesseRHServiceProtocol = VitesseRHService()) {
        self._candidate = candidate
        self.token = token
        self.candidateId = candidateId
        self.service = service
    }
    
    func saveChanges() async {
        errorMessage = nil
        guard candidate.email.isValidEmail() else {
            errorMessage = VitesseRHError.validation(.invalidEmail).localizedDescription
            return
        }
        if !candidate.phone.isEmpty && !candidate.phone.isValidFrPhone() {
            errorMessage = VitesseRHError.validation(.invalidPhone).localizedDescription
            return
        }
        if let url = candidate.linkedinURL, !url.isEmpty, URL(string: url)?.scheme == nil {
            errorMessage = VitesseRHError.validation(.invalidLinkedInURL).localizedDescription
            return
        }
        let result = await service.updateCandidate(candidate: candidate)
        switch result {
        case .success(let updatedCandidate):
            candidate = updatedCandidate
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}

