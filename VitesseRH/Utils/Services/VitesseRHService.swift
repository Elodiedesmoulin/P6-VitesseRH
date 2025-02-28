//
//  VitesseRHService.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

class VitesseRHService: APIService {
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Result<T, VitesseRHError> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.server(.invalidResponse))
        }
    }
    
    func getCandidates() async -> Result<[Candidate], VitesseRHError> {
        guard let url = APIEndpoint.candidates.url else {
            return .failure(.network(.invalidURL))
        }
        let config = RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decode([Candidate].self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getCandidate(withId candidateId: String) async -> Result<Candidate, VitesseRHError> {
        guard let url = APIEndpoint.candidate(candidateId).url else {
            return .failure(.network(.invalidURL))
        }
        let config = RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decode(Candidate.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func addCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError> {
        guard let url = APIEndpoint.candidates.url else {
            return .failure(.network(.invalidURL))
        }
        let config = RequestConfig(method: .post, url: url, parameters: candidate.parameters, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decode(Candidate.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func updateCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError> {
        guard let url = APIEndpoint.candidate(candidate.id).url else {
            return .failure(.network(.invalidURL))
        }
        let config = RequestConfig(method: .put, url: url, parameters: candidate.parameters, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decode(Candidate.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func favoriteToggle(forId candidateId: String) async -> Result<Candidate, VitesseRHError> {
        guard let url = APIEndpoint.favorite(candidateId).url else {
            return .failure(.network(.invalidURL))
        }
        let config = RequestConfig(method: .post, url: url, parameters: nil, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decode(Candidate.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func deleteCandidate(withId candidateId: String) async -> Result<Bool, VitesseRHError> {
        guard let url = APIEndpoint.candidate(candidateId).url else {
            return .failure(.network(.invalidURL))
        }
        let config = RequestConfig(method: .delete, url: url, parameters: nil, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success:
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func logIn(withEmail email: String, andPassword password: String) async -> Result<AuthenticationResponse, VitesseRHError> {
        guard let url = APIEndpoint.auth.url else {
            return .failure(.network(.invalidURL))
        }
        let params: [String: AnyHashable] = [
            UserKeys.email: email,
            UserKeys.password: password
        ]
        let config = RequestConfig(method: .post, url: url, parameters: params, requiresAuth: false)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decode(AuthenticationResponse.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func register(mail: String, password: String, firstName: String, lastName: String) async -> Result<Bool, VitesseRHError> {
        guard let url = APIEndpoint.register.url else {
            return .failure(.network(.invalidURL))
        }
        let params: [String: AnyHashable] = [
            UserKeys.email: mail,
            UserKeys.password: password,
            UserKeys.firstName: firstName,
            UserKeys.lastName: lastName
        ]
        let config = RequestConfig(method: .post, url: url, parameters: params, requiresAuth: false)
        let result = await executeRequest(config: config)
        switch result {
        case .success:
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension VitesseRHService: AuthenticationServiceProtocol {}
extension VitesseRHService: VitesseRHServiceProtocol {}
