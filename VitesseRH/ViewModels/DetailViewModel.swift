//
//  DetailsViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation
import SwiftUI

final class DetailViewModel: ObservableObject {
    let service: VitesseRHServiceProtocol
    @Published var candidate: Candidate
    @Published var errorMessage: String? = nil
    var token: String
    var isAdmin: Bool

    init(token: String, candidate: Candidate, isAdmin: Bool, service: VitesseRHServiceProtocol = VitesseRHService()) {
        self.service = service
        self.token = token
        self.candidate = candidate
        self.isAdmin = isAdmin
    }

    func toggleFavorite() {
        candidate.isFavorite.toggle()
        Task {
            let result = await service.favoriteToggle(forId: candidate.id)
            await MainActor.run {
                switch result {
                case .success(let updatedCandidate):
                    self.candidate = updatedCandidate
                case .failure(let error):
                    self.candidate.isFavorite.toggle()
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchCandidateDetails() {
        Task {
            let result = await service.getCandidate(withId: candidate.id)
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
}
