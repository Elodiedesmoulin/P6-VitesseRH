//
//  ApiPath.swift
//  VitesseRH
//
//  Created by Elo on 28/01/2025.
//

import Foundation

enum APIEndpoint {
    private static let baseURLString = "http://127.0.0.1:8080"
    
    case auth, register, candidates, candidate(String), favorite(String)
    
    var url: URL? {
        var components = URLComponents(string: APIEndpoint.baseURLString)
        switch self {
        case .auth:
            components?.path = "/user/auth"
        case .register:
            components?.path = "/user/register"
        case .candidates:
            components?.path = "/candidate"
        case .candidate(let id):
            components?.path = "/candidate/\(id)"
        case .favorite(let id):
            components?.path = "/candidate/\(id)/favorite"
        }
        return components?.url
    }
}
