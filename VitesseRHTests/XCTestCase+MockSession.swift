//
//  FakeResponseData.swift
//  VitesseRHTests
//
//  Created by Elo on 20/01/2025.
//


import Foundation
import XCTest

@testable import VitesseRH

extension XCTestCase {
    
    func loadJSONData(filename: String) -> Data? {
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: filename, withExtension: "json") else {
                XCTFail("Impossible to find \(filename).json")
                return nil
            }
            return try? Data(contentsOf: url)
        }
    
    func makeHTTPResponse(url: URL, statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    func makeMockSession(data: Data, statusCode: Int, path: APIEndpoint) -> MockSession {
        let url = path.url!
        let session = MockSession()
        let response = makeHTTPResponse(url: url, statusCode: statusCode)
        
        session.dataTaskHandler = { (request, delegate) async throws -> (Data, URLResponse) in
            return (data, response)
        }
        return session
    }
    
    func makeFailingMockSession(error: NSError) -> MockSession {
        let session = MockSession()
        session.dataTaskHandler = { (request, delegate) async throws -> (Data, URLResponse) in
            throw error
        }
        return session
    }
    
    func makeService(withSession session: SessionProtocol) -> VitesseRHService {
        return VitesseRHService(session: session)
    }

}





