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
    @Binding var candidate: Candidate
    @Published var errorMessage: String?
    var token: String
    var isAdmin: Bool

    init(candidate: Binding<Candidate>, token: String, isAdmin: Bool, service: VitesseRHServiceProtocol = VitesseRHService()) {
        self._candidate = candidate
        self.token = token
        self.isAdmin = isAdmin
        self.service = service
    }
    
    func toggleFavorite() {
        candidate.isFavorite.toggle()
        Task {
            let result = await service.favoriteToggle(forId: candidate.id)
            await MainActor.run {
                switch result {
                case .success(let updatedCandidate):
                    candidate = updatedCandidate
                case .failure(let error):
                    candidate.isFavorite.toggle()
                    errorMessage = error.localizedDescription
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
                    candidate = updatedCandidate
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
