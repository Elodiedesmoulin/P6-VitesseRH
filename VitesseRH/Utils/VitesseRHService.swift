//
//  VitesseRHService.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

class VitesseRHService {
    
    let baseUrl = "http://127.0.0.1:8080"
    let session: SessionProtocol
    
    init(session: SessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    
    
    private func createRequest(
        endpoint: String,
        method: String,
        token: String? = nil,
        parameters: [String: Any]? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw VitesseRHError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let parameters = parameters {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
                throw VitesseRHError.invalidParameters
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
        }
        return request
    }
    
    private func handleResponse<T: Decodable>(_ data: Data, _ response: URLResponse, decodingType: T.Type) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw VitesseRHError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw VitesseRHError.invalidAuthentication
        } else if httpResponse.statusCode >= 400 {
            throw VitesseRHError.unknown
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    
    
    // Authentication
    func login(email: String, password: String) async throws -> (String, Bool) {
        let parameters = ["email": email, "password": password]
        let request = try createRequest(endpoint: "/user/auth", method: "POST", parameters: parameters)
        let (data, response) = try await session.data(for: request)
        let authenticationResponse: AuthenticationResponse = try handleResponse(data, response, decodingType: AuthenticationResponse.self)
        return (authenticationResponse.token, authenticationResponse.isAdmin)
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) async throws {
        let parameters = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password
        ]
        let request = try createRequest(endpoint: "/user/register", method: "POST", parameters: parameters)
        let (_, response) = try await session.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
            throw VitesseRHError.invalidResponse
        }
    }
    
    
    
    
    // Candidates
    func getCandidates(token: String) async throws -> [Candidate] {
        let request = try createRequest(endpoint: "/candidate", method: "GET", token: token)
        let (data, response) = try await session.data(for: request)
        return try handleResponse(data, response, decodingType: [Candidate].self)
    }
    
    func getCandidateDetails(token: String, candidateId: String) async throws -> Candidate {
        let request = try createRequest(endpoint: "/candidate/\(candidateId)", method: "GET", token: token)
        let (data, response) = try await session.data(for: request)
        return try handleResponse(data, response, decodingType: Candidate.self)
    }
    
    func createCandidate(token: String, candidate: Candidate) async throws {
        let parameters = try candidate.asDictionary()
        let request = try createRequest(endpoint: "/candidate", method: "POST", token: token, parameters: parameters)
        let (_, response) = try await session.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
            throw VitesseRHError.invalidResponse
        }
    }
    
    func updateCandidate(token: String, candidateId: String, candidate: Candidate) async throws {
        let parameters = try candidate.asDictionary()
        let request = try createRequest(endpoint: "/candidate/\(candidateId)", method: "PUT", token: token, parameters: parameters)
        let (_, response) = try await session.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
            throw VitesseRHError.invalidResponse
        }
    }
    
    func deleteCandidate(token: String, candidateId: String) async throws {
        let request = try createRequest(endpoint: "/candidate/\(candidateId)", method: "DELETE", token: token)
        let (_, response) = try await session.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
            throw VitesseRHError.invalidResponse
        }
    }
    
    func toggleFavoriteStatus(token: String, candidateId: String) async throws {
        let request = try createRequest(endpoint: "/candidate/\(candidateId)/favorite", method: "POST", token: token)
        let (_, response) = try await session.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
            throw VitesseRHError.invalidResponse
        }
    }
}
