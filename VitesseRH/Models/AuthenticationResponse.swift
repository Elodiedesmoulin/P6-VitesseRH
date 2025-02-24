//
//  AuthenticationResponse.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

struct AuthenticationResponse: Codable, Equatable {
    let token: String
    let isAdmin: Bool
}
