//
//  MockVitesseRHService.swift
//  VitesseRHTests
//
//  Created by Elo on 17/02/2025.
//

import XCTest
@testable import VitesseRH

class MockVitesseRHService: VitesseRHServiceProtocol {
    
    var getCandidatesResult: Result<[Candidate], VitesseRHError> = .failure(.unknown)
    var getCandidateResult: Result<Candidate, VitesseRHError> = .failure(.unknown)
    var addCandidateResult: Result<Candidate, VitesseRHError> = .failure(.unknown)
    var updateCandidateResult: Result<Candidate, VitesseRHError> = .failure(.unknown)
    var favoriteToggleResult: Result<Candidate, VitesseRHError> = .failure(.unknown)
    var deleteCandidateResult: Result<Bool, VitesseRHError> = .failure(.unknown)
    var registerResult: Result<Bool, VitesseRHError> = .failure(.unknown)
    var logInResult: Result<AuthenticationResponse, VitesseRHError> = .failure(.unknown)
    
    func getCandidates() async -> Result<[Candidate], VitesseRHError> {
        return getCandidatesResult
    }
    
    func getCandidate(withId candidateId: String) async -> Result<Candidate, VitesseRHError> {
        return getCandidateResult
    }
    
    func addCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError> {
        return addCandidateResult
    }
    
    func updateCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError> {
        return updateCandidateResult
    }
    
    func favoriteToggle(forId candidateId: String) async -> Result<Candidate, VitesseRHError> {
        return favoriteToggleResult
    }
    
    func deleteCandidate(withId candidateId: String) async -> Result<Bool, VitesseRHError> {
        return deleteCandidateResult
    }
    
    func register(mail: String, password: String, firstName: String, lastName: String) async -> Result<Bool, VitesseRHError> {
        return registerResult
    }
    
    func logIn(withEmail email: String, andPassword password: String) async -> Result<AuthenticationResponse, VitesseRHError> {
        return logInResult
    }
}
