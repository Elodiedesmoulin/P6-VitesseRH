//
//  CreateCandidateListView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

class CreateCandidateViewModel: ObservableObject {
    @Published var errorMessage: String?
    
    private let service: VitesseRHService
    private var token: String
    
    init(service: VitesseRHService = VitesseRHService(), token: String) {
        self.service = service
        self.token = token
    }
    
    func addCandidate(_ candidate: Candidate) {
        Task {
            do {
                try await service.createCandidate(token: token, candidate: candidate)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to add candidate."
                }
            }
        }
    }
}
