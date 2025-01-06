//
//  EditingViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

class EditingViewModel: ObservableObject {
    @Published var candidate: Candidate
    private var token: String
    private var candidateId: String
    private var service: VitesseRHService  

    init(candidate: Candidate, token: String, candidateId: String, service: VitesseRHService) {
        self.candidate = candidate
        self.token = token
        self.candidateId = candidateId
        self.service = service
    }

    func saveChanges() {
        Task {
            do {
                try await service.updateCandidate(token: token, candidateId: candidateId, candidate: candidate)
                DispatchQueue.main.async {
                    print("Changes saved successfully")  
                }
            } catch {
                DispatchQueue.main.async {
                    print("Failed to save changes")
                }
            }
        }
    }
}
