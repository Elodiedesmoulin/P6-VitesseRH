//
//  ApiPath.swift
//  VitesseRH
//
//  Created by Elo on 28/01/2025.
//

import Foundation

enum ApiPath {
    private static let baseURLString = "http://127.0.0.1:8080"
    
    case auth, register, candidates, candidate(String), favorite(String)
    
    var url: URL? {
        guard var components = URLComponents(string: ApiPath.baseURLString) else { return nil }
        switch self {
        case .auth:
            components.path = "/user/auth"
        case .register:
            components.path = "/user/register"
        case .candidates:
            components.path = "/candidate"
        case .candidate(let candidateId):
            components.path = "/candidate/\(candidateId)"
        case .favorite(let candidateId):
            components.path = "/candidate/\(candidateId)/favorite"
        }
        return components.url
    }
}
