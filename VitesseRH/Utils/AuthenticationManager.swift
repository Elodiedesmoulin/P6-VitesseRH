//
//  AuthManager.swift
//  VitesseRH
//
//  Created by Elo on 29/01/2025.
//

import Foundation

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private var token: String?
    private var isAdminUser = false
    
    private init() {}
    
    func saveAuthData(_ response: AuthenticationResponse) {
        token = response.token
        isAdminUser = response.isAdmin
    }
    
    func getToken() -> String? { token }
    func isAdmin() -> Bool { isAdminUser }
    
    func deleteAuthData() {
        token = nil
        isAdminUser = false
    }
}
