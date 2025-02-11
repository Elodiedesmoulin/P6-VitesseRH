//
//  VitesseRHServiceTests.swift
//  VitesseRHTests
//
//  Created by Elo on 17/01/2025.
//

import XCTest
@testable import VitesseRH
//final class VitesseRHServiceTests: XCTestCase {
//    
//    
//    func testLoginWithValidCredentials() async throws {
//        let mockSession = MockSession()
//        mockSession.nextData = "{\"token\": \"valid_token\", \"isAdmin\": false}".data(using: .utf8)
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        let (token, isAdmin) = try await service.login(email: "test@example.com", password: "password")
//        
//        XCTAssertEqual(token, "valid_token")
//        XCTAssertFalse(isAdmin)
//    }
//
//    func testLoginWithInvalidCredentials() async {
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 401, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        do {
//                _ = try await service.login(email: "test@example.com", password: "wrongpassword")
//                XCTFail("Expected error to be thrown, but it wasn't")
//            } catch {
//                XCTAssertEqual(error as? VitesseRHError, .invalidAuthentication)
//            }
//    }
//
//    func testRegisterWithValidData() async throws {
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 201, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        try await service.register(firstName: "John", lastName: "Doe", email: "john@example.com", password: "password")
//        
//        XCTAssertTrue(true)
//    }
//
//    func testRegisterWithInvalidResponse() async {
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 400, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            try await service.register(firstName: "John", lastName: "Doe", email: "john@example.com", password: "password")
//            XCTFail("Expected error to be thrown, but it wasn't")
//        } catch {
//            XCTAssertEqual(error as? VitesseRHError, .invalidResponse)
//        }
//    }
//    
//    
//    // Tests pour `createRequest`
//    func testCreateRequestWithValidURL() throws {
//        let service = VitesseRHService()
//        let request = try service.createRequest(endpoint: "/test", method: "GET")
//        XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080/test")
//        XCTAssertEqual(request.httpMethod, "GET")
//    }
//
//    func testCreateRequestWithInvalidURL() {
//        let service = VitesseRHService()
//        XCTAssertThrowsError(try service.createRequest(endpoint: "://invalid-url", method: "GET")) { error in
//            XCTAssertEqual(error as? VitesseRHError, .invalidUrl)
//        }
//    }
//
//    func testCreateRequestWithParameters() throws {
//        let service = VitesseRHService()
//        let parameters = ["key": "value"]
//        let request = try service.createRequest(endpoint: "/test", method: "POST", parameters: parameters)
//        XCTAssertEqual(request.httpMethod, "POST")
//        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
//    }
//
//    // Tests pour `handleResponse`
//    func testHandleResponseWithValidData() throws {
//        let service = VitesseRHService()
//        let data = "{\"token\": \"abc123\", \"isAdmin\": true}".data(using: .utf8)!
//        let response = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
//        let decodedResponse: AuthenticationResponse = try service.handleResponse(data, response, decodingType: AuthenticationResponse.self)
//        XCTAssertEqual(decodedResponse.token, "abc123")
//        XCTAssertTrue(decodedResponse.isAdmin)
//    }
//
//    func testHandleResponseWithInvalidData() {
//        let service = VitesseRHService()
//        let data = "invalid".data(using: .utf8)!
//        let response = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
//        XCTAssertThrowsError(try service.handleResponse(data, response, decodingType: AuthenticationResponse.self)) { error in
//            XCTAssert(error is DecodingError)
//        }
//    }
//
//    func testHandleResponseWith401Status() {
//        let service = VitesseRHService()
//        let data = Data()
//        let response = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 401, httpVersion: nil, headerFields: nil)!
//        XCTAssertThrowsError(try service.handleResponse(data, response, decodingType: AuthenticationResponse.self)) { error in
//            XCTAssertEqual(error as? VitesseRHError, .invalidAuthentication)
//        }
//    }
//    
//    func testRegisterWithValidResponse() async {
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 201, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            try await service.register(firstName: "John", lastName: "Doe", email: "john@example.com", password: "password")
//        } catch {
//            XCTFail("Expected no error to be thrown, but got \(error)")
//        }
//    }
//    
//    func testGetCandidatesWithValidResponse() async throws {
//        let mockCandidates = [
//            Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false),
//            Candidate(id: "2", firstName: "Bob", lastName: "Jones", email: "bob@example.com", phone: "0987654321", note: nil, linkedinURL: nil, isFavorite: true)
//        ]
//        
//        let mockSession = MockSession()
//        let mockData = try JSONEncoder().encode(mockCandidates)
//        mockSession.nextData = mockData
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            let candidates = try await service.getCandidates(token: "validToken")
//            XCTAssertEqual(candidates, mockCandidates)
//        } catch {
//            XCTFail("Expected no error to be thrown, but got \(error)")
//        }
//    }
//    
//    func testGetCandidatesWithAuthenticationError() async {
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 401, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            _ = try await service.getCandidates(token: "invalidToken")
//            XCTFail("Expected error to be thrown, but it wasn't")
//        } catch {
//            XCTAssertEqual(error as? VitesseRHError, .invalidAuthentication)
//        }
//    }
//    
//    
//    
//    
//    func testGetCandidateDetailsWithValidResponse() async throws {
//        let mockCandidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
//        
//        let mockSession = MockSession()
//        let mockData = try JSONEncoder().encode(mockCandidate)
//        mockSession.nextData = mockData
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            let candidate = try await service.getCandidateDetails(token: "validToken", candidateId: "1")
//            XCTAssertEqual(candidate, mockCandidate)
//        } catch {
//            XCTFail("Expected no error to be thrown, but got \(error)")
//        }
//    }
//    
//    func testGetCandidateDetailsWithAuthenticationError() async {
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 401, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            _ = try await service.getCandidateDetails(token: "invalidToken", candidateId: "1")
//            XCTFail("Expected error to be thrown, but it wasn't")
//        } catch {
//            XCTAssertEqual(error as? VitesseRHError, .invalidAuthentication)
//        }
//    }
//    
//    
//    func testCreateCandidateWithValidResponse() async throws {
//        let mockCandidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
//        
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 201, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            try await service.createCandidate(token: "validToken", candidate: mockCandidate)
//        } catch {
//            XCTFail("Expected no error to be thrown, but got \(error)")
//        }
//    }
//    
//    
//    func testCreateCandidateWithInvalidResponse() async {
//        let mockCandidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
//        
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 400, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            try await service.createCandidate(token: "validToken", candidate: mockCandidate)
//            XCTFail("Expected error to be thrown, but it wasn't")
//        } catch {
//            XCTAssertEqual(error as? VitesseRHError, .invalidResponse)
//        }
//    }
//    
//    func testUpdateCandidateWithValidResponse() async throws {
//        let jsonCandidate = """
//            {
//                "id": "1",
//                "firstName": "Alice",
//                "lastName": "Smith",
//                "email": "alice@example.com",
//                "phone": "1234567890",
//                "note": null,
//                "linkedinURL": null,
//                "isFavorite": false
//            } 
//        """
//        let mockCandidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
//        
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//        mockSession.nextData = jsonCandidate.data(using: .utf8)
//        let service = VitesseRHService(session: mockSession)
//        
//        
//        let candidate = try await service.updateCandidate(token: "validToken", candidate: mockCandidate)
//        XCTAssertEqual(candidate, mockCandidate)
//        
//    }
//    
//    func testUpdateCandidateWithInvalidResponse() async {
//        let mockCandidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
//        
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 400, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            _ = try await service.updateCandidate(token: "validToken", candidate: mockCandidate)
//            XCTFail("Expected error to be thrown, but it wasn't")
//        } catch {
//            XCTAssertEqual(error as? VitesseRHError, .invalidResponse)
//        }
//    }
//    
//    
//    func testDeleteCandidateWithValidResponse() async throws {
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            try await service.deleteCandidate(token: "validToken", candidateId: "1")
//        } catch {
//            XCTFail("Expected no error to be thrown, but got \(error)")
//        }
//    }
//    
//    
//    func testDeleteCandidateWithInvalidResponse() async {
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 400, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            try await service.deleteCandidate(token: "validToken", candidateId: "1")
//            XCTFail("Expected error to be thrown, but it wasn't")
//        } catch {
//            XCTAssertEqual(error as? VitesseRHError, .invalidResponse)
//        }
//    }
//    
//    
//    func testToggleFavoriteStatusWithValidResponse() async throws {
//        let mockSession = MockSession()
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//        
//        let service = VitesseRHService(session: mockSession)
//        
//        do {
//            try await service.toggleFavoriteStatus(token: "validToken", candidateId: "1")
//        } catch {
//            XCTFail("Expected no error to be thrown, but got \(error)")
//        }
//    }
//}

