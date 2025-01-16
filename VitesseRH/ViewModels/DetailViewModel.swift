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
    @Published var candidates = [Candidate]()
    
    var service: VitesseRHService
    var token: String
    var candidateId: String
    var isAdmin: Bool
    
    init(service: VitesseRHService = VitesseRHService(), token: String, candidateId: String, isAdmin: Bool) {
        self.service = service
        self.token = token
        self.candidateId = candidateId
        self.isAdmin = isAdmin
        fetchCandidateDetails()
    }
    
    func fetchCandidateDetails() {
        Task {
            do {
                let candidateDetails = try await service.getCandidateDetails(token: token, candidateId: candidateId)
                DispatchQueue.main.async {
                    self.candidate = candidateDetails
                }
            } catch let error as VitesseRHError {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = VitesseRHError.unknown.localizedDescription
                }
            }
        }
    }
    
    func toggleFavorite() {
        guard let candidate = candidate, isAdmin else {
            DispatchQueue.main.async {
                self.errorMessage = VitesseRHError.permissionDenied.localizedDescription
            }
            return
        }
        Task {
            do {
                try await service.toggleFavoriteStatus(token: token, candidateId: candidate.id)
                DispatchQueue.main.async {
                    self.candidate?.isFavorite.toggle()
                }
            } catch let error as VitesseRHError {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = VitesseRHError.unknown.localizedDescription
                }
            }
        }
    }
}
