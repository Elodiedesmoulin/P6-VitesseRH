//
//  AuthenticationProtocol.swift
//  VitesseRH
//
//  Created by Elo on 12/02/2025.
//

import Foundation

protocol AuthenticationServiceProtocol {
    func logIn(withEmail email: String, andPassword password: String) async -> Result<AuthenticationResponse, VitesseRHError>
}
