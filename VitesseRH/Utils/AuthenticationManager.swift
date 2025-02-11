//
//  AuthManager.swift
//  VitesseRH
//
//  Created by Elo on 29/01/2025.
//

import Foundation

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private var token: String?
    private var isUserAdmin = false
    
    private init() {}
    
    func saveAuthData(_ response: AuthenticationResponse) {
        token = response.token
        isUserAdmin = response.isAdmin
    }
    
    func getToken() -> String? { token }
    
    func isAdmin() -> Bool { isUserAdmin }
    
    func deleteAuthData() {
        token = nil
        isUserAdmin = false
    }
}
