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
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error { throw error }
        guard let data = data, let urlResponse = urlResponse else {
            throw NSError(domain: "MockSession", code: 0, userInfo: nil)
        }
        return (data, urlResponse)
    }
}
