//
//  VitesseRHServiceProtocol.swift
//  VitesseRH
//
//  Created by Elo on 24/02/2025.
//

import Foundation

protocol VitesseRHServiceProtocol {
    func getCandidates() async -> Result<[Candidate], VitesseRHError>
    func getCandidate(withId candidateId: String) async -> Result<Candidate, VitesseRHError>
    func addCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError>
    func updateCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError>
    func favoriteToggle(forId candidateId: String) async -> Result<Candidate, VitesseRHError>
    func deleteCandidate(withId candidateId: String) async -> Result<Bool, VitesseRHError>
    func register(mail: String, password: String, firstName: String, lastName: String) async -> Result<Bool, VitesseRHError>
    func logIn(withEmail email: String, andPassword password: String) async -> Result<AuthenticationResponse, VitesseRHError>
}
