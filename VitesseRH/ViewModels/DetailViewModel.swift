//
//  DetailsViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var candidate: Candidate?
    @Published var errorMessage: String?
    
    var service: VitesseRHService
    var token: String
    var candidateId: String
    
    init(service: VitesseRHService = VitesseRHService(), token: String, candidateId: String) {
        self.service = service
        self.token = token
        self.candidateId = candidateId
        fetchCandidateDetails()
    }
    
    func fetchCandidateDetails() {
        Task {
            do {
                let candidateDetails = try await service.getCandidateDetails(token: token, candidateId: candidateId)
                DispatchQueue.main.async {
                    self.candidate = candidateDetails
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load candidate details."
                }
            }
        }
    }
}
