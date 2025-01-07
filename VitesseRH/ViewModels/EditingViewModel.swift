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
    
    init(candidate: Candidate, token: String, candidateId: String, service: VitesseRHService) {
        self.candidate = candidate
        self.token = token
        self.candidateId = candidateId
        self.service = service
    }
    
    func saveChanges(for candidate: Candidate) {
        Task {
            do {
                try await service.updateCandidate(token: token, candidateId: candidate.id, candidate: candidate)
            } catch {
                DispatchQueue.main.async {
                    print("Failed to save changes")
                }
            }
        }
    }
}
