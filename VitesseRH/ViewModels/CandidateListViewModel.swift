//
//  CandidateListViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation
import Combine

class CandidateListViewModel: ObservableObject {
    @Published var candidates = [Candidate]()
    @Published var filteredCandidates = [Candidate]()
    @Published var errorMessage: String?
    
    private let service: VitesseRHService
    private var token: String
    private var cancellables = Set<AnyCancellable>()
    
    init(service: VitesseRHService = VitesseRHService(), token: String) {
        self.service = service
        self.token = token
        fetchCandidates()
    }
    
    func fetchCandidates() {
        Task {
            do {
                let candidates = try await service.getCandidates(token: token)
                DispatchQueue.main.async {
                    self.candidates = candidates
                    self.filteredCandidates = candidates

                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load candidates."
                }
            }
        }
    }
    
    func toggleFavorite(for candidate: Candidate) {
        
        Task {
            do {
                try await service.toggleFavoriteStatus(token: token, candidateId: candidate.id)
                fetchCandidates()
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to update favorite status."
                }
            }
        }
    }
    
    func filterCandidates(by searchText: String) {
            if searchText.isEmpty {
                filteredCandidates = candidates
            } else {
                filteredCandidates = candidates.filter { candidate in
                    candidate.lastName.lowercased().contains(searchText.lowercased()) ||
                    candidate.firstName.lowercased().contains(searchText.lowercased())
                }
            }
        }
}
