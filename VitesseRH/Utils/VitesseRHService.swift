//
//  VitesseRHService.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

class VitesseRHService: ApiService {
    
    private func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data) -> Result<T, VitesseRHError> {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(.server(.invalidResponse))
        }
    }
    
    func getCandidates() async -> Result<[Candidate], VitesseRHError> {
        guard let url = ApiPath.candidates.url else { return .failure(.network(.invalidURL))}
        let config = RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decodeResponse([Candidate].self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getCandidate(withId candidateId: String) async -> Result<Candidate, VitesseRHError> {
        guard let url = ApiPath.candidate(candidateId).url else { return .failure(.network(.invalidURL))}
        let config = RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decodeResponse(Candidate.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func addCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError> {
        guard let url = ApiPath.candidates.url else { return .failure(.network(.invalidURL))}
        let parameters: [String: AnyHashable] = [
            "email": candidate.email,
            "note": candidate.note ?? "",
            "linkedinURL": candidate.linkedinURL ?? "",
            "firstName": candidate.firstName,
            "lastName": candidate.lastName,
            "phone": candidate.phone
        ]
        let config = RequestConfig(method: .post, url: url, parameters: parameters, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decodeResponse(Candidate.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func updateCandidate(candidate: Candidate) async -> Result<Candidate, VitesseRHError> {
        guard let url = ApiPath.candidate(candidate.id).url else { return .failure(.network(.invalidURL))}
        let parameters: [String: AnyHashable] = [
            "email": candidate.email,
            "note": candidate.note ?? "",
            "linkedinURL": candidate.linkedinURL ?? "",
            "firstName": candidate.firstName,
            "lastName": candidate.lastName,
            "phone": candidate.phone
        ]
        let config = RequestConfig(method: .put, url: url, parameters: parameters, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decodeResponse(Candidate.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func favoriteToggle(forId candidateId: String) async -> Result<Candidate, VitesseRHError> {
        guard let url = ApiPath.favorite(candidateId).url else { return .failure(.network(.invalidURL))}
        let config = RequestConfig(method: .post, url: url, parameters: nil, requiresAuth: true)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decodeResponse(Candidate.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func deleteCandidate(withId candidateId: String) async -> Result<Bool, VitesseRHError> {
        guard let url = ApiPath.candidate(candidateId).url else { return .failure(.network(.invalidURL))}
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
        guard let url = ApiPath.auth.url else { return .failure(.network(.invalidURL))}
        let parameters: [String: AnyHashable] = [UserConstants.email: email, UserConstants.password: password]
        let config = RequestConfig(method: .post, url: url, parameters: parameters, requiresAuth: false)
        let result = await executeRequest(config: config)
        switch result {
        case .success(let data):
            return decodeResponse(AuthenticationResponse.self, from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func register(mail: String, password: String, firstName: String, lastName: String) async -> Result<Bool, VitesseRHError> {
        guard let url = ApiPath.register.url else { return .failure(.network(.invalidURL))}
        let parameters: [String: AnyHashable] = [
            UserConstants.email: mail,
            UserConstants.password: password,
            UserConstants.firstName: firstName,
            UserConstants.lastName: lastName
        ]
        let config = RequestConfig(method: .post, url: url, parameters: parameters, requiresAuth: false)
        let result = await executeRequest(config: config)
        switch result {
        case .success:
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
}
