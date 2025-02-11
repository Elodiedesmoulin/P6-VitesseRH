//
//  FakeResponseData.swift
//  VitesseRHTests
//
//  Created by Elo on 20/01/2025.
//


import Foundation
import XCTest

@testable import VitesseRH

class MockVitesseRHService: VitesseRHService {
    var getCandidatesResult: Result<[Candidate], VitesseRHError>?
    var getCandidateResult: Result<Candidate, VitesseRHError>?
    var addCandidateResult: Result<Candidate, VitesseRHError>?
    var updateCandidateResult: Result<Candidate, VitesseRHError>?
    var favoriteToggleResult: Result<Candidate, VitesseRHError>?
    var deleteCandidateResult: Result<Bool, VitesseRHError>?
    var logInResult: Result<AuthenticationResponse, VitesseRHError>?
    var registerResult: Result<Bool, VitesseRHError>?
    
    override func getCandidates() async -> Result<[Candidate], VitesseRHError> {
        return getCandidatesResult ?? .failure(.unknown)
    }
    
    override func getCandidate(withId candidateId: String) async -> Result<Candidate, VitesseRHError> {
        return getCandidateResult ?? .failure(.unknown)
    }
    
    override func addCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError> {
        return addCandidateResult ?? .failure(.unknown)
    }
    
    override func updateCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError> {
        return updateCandidateResult ?? .failure(.unknown)
    }
    
    override func favoriteToggle(forId candidateId: String) async -> Result<Candidate, VitesseRHError> {
        return favoriteToggleResult ?? .failure(.unknown)
    }
    
    override func deleteCandidate(withId candidateId: String) async -> Result<Bool, VitesseRHError> {
        return deleteCandidateResult ?? .failure(.unknown)
    }
    
    override func logIn(withEmail email: String, andPassword password: String) async -> Result<AuthenticationResponse, VitesseRHError> {
        return logInResult ?? .failure(.unknown)
    }
    
    override func register(mail: String, password: String, firstName: String, lastName: String) async -> Result<Bool, VitesseRHError> {
        return registerResult ?? .failure(.unknown)
    }
}
