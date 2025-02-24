//
//  MockSession.swift
//  VitesseRHTests
//
//  Created by Elo on 17/01/2025.
//

import Foundation
import XCTest

@testable import VitesseRH

class MockSession: SessionProtocol {
    var dataTaskHandler: ((URLRequest, URLSessionTaskDelegate?) async throws -> (Data, URLResponse))?
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let handler = dataTaskHandler {
            return try await handler(request, delegate)
        }
        throw NSError(domain: "MockSession", code: 0, userInfo: [NSLocalizedDescriptionKey: "No handler defined"])
    }
}

class MockAuthenticationService: AuthenticationServiceProtocol {
    var logInResult: Result<AuthenticationResponse, VitesseRHError>?
    
    func logIn(withEmail email: String, andPassword password: String) async -> Result<AuthenticationResponse, VitesseRHError> {
        return logInResult!
    }
}
