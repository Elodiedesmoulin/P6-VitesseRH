//
//  VitesseRHServiceTests.swift
//  VitesseRHTests
//
//  Created by Elo on 17/01/2025.
//

import XCTest
@testable import VitesseRH

final class VitesseRHServiceTests: XCTestCase {
    
    override func setUpWithError() throws{
        try super.setUpWithError()
        if let data = loadJSONData(filename: "Authentication") {
            let decoder = JSONDecoder()
            let authResponse = try decoder.decode(AuthenticationResponse.self, from: data)
                AuthenticationManager.shared.saveAuthData(authResponse)
            
        } else {
            XCTFail("Impossible to load Authentication.json")
        }
    }
    
    override func tearDown() {
        AuthenticationManager.shared.deleteAuthData()
        super.tearDown()
    }
    
    
    func testGetCandidatesWithValidDataShouldReturnCandidates() async {
        guard let data = loadJSONData(filename: "Candidates") else { return }
        let mockSession = makeMockSession(data: data, statusCode: 200, path: .candidates)
        let service = makeService(withSession: mockSession)
        
        let result = await service.getCandidates()
        switch result {
        case .success(let candidates):
            XCTAssertEqual(candidates.count, 2)
            XCTAssertEqual(candidates.first?.firstName, "Alice")
            XCTAssertEqual(candidates.last?.firstName, "Bob")
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testGetCandidatesWithOfflineNetworkShouldFailWithOfflineError() async {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let mockSession = makeFailingMockSession(error: error)
        let service = makeService(withSession: mockSession)
        
        let result = await service.getCandidates()
        switch result {
        case .success:
            XCTFail("Expected failure due to offline network, but got success")
        case .failure(let error):
            if case VitesseRHError.network(let netError) = error {
                XCTAssertEqual(netError.localizedDescription, NetworkError.offline.localizedDescription)
            } else {
                XCTFail("Expected network offline error, got: \(error)")
            }
        }
    }
    
    // MARK: - getCandidate Tests
    
    func testGetCandidateWithValidIdShouldReturnCandidate() async {
        let candidateDetailJSON = """
        {
            "id": "1",
            "firstName": "Alice",
            "lastName": "Smith",
            "email": "alice@example.com",
            "phone": "1234567890",
            "note": null,
            "linkedinURL": null,
            "isFavorite": false
        }
        """
        let data = candidateDetailJSON.data(using: .utf8)!
        let mockSession = makeMockSession(data: data, statusCode: 200, path: .candidate("1"))
        let service = makeService(withSession: mockSession)
        
        let result = await service.getCandidate(withId: "1")
        switch result {
        case .success(let candidate):
            XCTAssertEqual(candidate.id, "1")
            XCTAssertEqual(candidate.firstName, "Alice")
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testGetCandidateWithNonexistentIdShouldFailWithNotFoundError() async {
        let data = Data()
        let mockSession = makeMockSession(data: data, statusCode: 404, path: .candidate("1"))
        let service = makeService(withSession: mockSession)
        
        let result = await service.getCandidate(withId: "1")
        switch result {
        case .success:
            XCTFail("Expected failure due to 404 Not Found")
        case .failure(let error):
            if case VitesseRHError.server(let srvError) = error {
                XCTAssertEqual(srvError.localizedDescription, ServerError.notFound.localizedDescription)
            } else {
                XCTFail("Expected server not found error, got: \(error)")
            }
        }
    }
    
    // MARK: - addCandidate Tests
    
    func testAddCandidateWithValidCandidateShouldReturnCreatedCandidate() async {
        let candidateDetailJSON = """
        {
            "id": "3",
            "firstName": "Charlie",
            "lastName": "Brown",
            "email": "charlie@example.com",
            "phone": "1112223333",
            "note": null,
            "linkedinURL": null,
            "isFavorite": false
        }
        """
        let data = candidateDetailJSON.data(using: .utf8)!
        let mockSession = makeMockSession(data: data, statusCode: 201, path: .candidates)
        let service = makeService(withSession: mockSession)
        
        let candidateToAdd = Candidate(id: "", firstName: "Charlie", lastName: "Brown", email: "charlie@example.com", phone: "1112223333", note: nil, linkedinURL: nil, isFavorite: false)
        let result = await service.addCandidate(candidate: candidateToAdd)
        switch result {
        case .success(let candidate):
            XCTAssertEqual(candidate.id, "3")
            XCTAssertEqual(candidate.firstName, "Charlie")
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testAddCandidateWithConflictShouldFailWithConflictError() async {
        let data = Data()
        let mockSession = makeMockSession(data: data, statusCode: 409, path: .candidates)
        let service = makeService(withSession: mockSession)
        
        let candidateToAdd = Candidate(id: "", firstName: "Charlie", lastName: "Brown", email: "charlie@example.com", phone: "1112223333", note: nil, linkedinURL: nil, isFavorite: false)
        let result = await service.addCandidate(candidate: candidateToAdd)
        switch result {
        case .success:
            XCTFail("Expected failure due to conflict")
        case .failure(let error):
            if case VitesseRHError.server(let srvError) = error {
                XCTAssertEqual(srvError.localizedDescription, ServerError.conflict.localizedDescription)
            } else {
                XCTFail("Expected server conflict error, got: \(error)")
            }
        }
    }
    
    // MARK: - updateCandidate Tests
    
    func testUpdateCandidateWithValidDataShouldReturnUpdatedCandidate() async {
        let candidateDetailJSON = """
        {
            "id": "1",
            "firstName": "Alice",
            "lastName": "Smith",
            "email": "alice_new@example.com",
            "phone": "1234567890",
            "note": "Updated note",
            "linkedinURL": null,
            "isFavorite": false
        }
        """
        let data = candidateDetailJSON.data(using: .utf8)!
        let mockSession = makeMockSession(data: data, statusCode: 200, path: .candidate("1"))
        let service = makeService(withSession: mockSession)
        
        let candidateToUpdate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice_new@example.com", phone: "1234567890", note: "Updated note", linkedinURL: nil, isFavorite: false)
        let result = await service.updateCandidate(candidate: candidateToUpdate)
        switch result {
        case .success(let candidate):
            XCTAssertEqual(candidate.email, "alice_new@example.com")
            XCTAssertEqual(candidate.note, "Updated note")
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testUpdateCandidateWithInvalidDataShouldFailWithUnprocessableEntityError() async {
        let data = Data()
        let mockSession = makeMockSession(data: data, statusCode: 422, path: .candidate("1"))
        let service = makeService(withSession: mockSession)
        
        let candidateToUpdate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice_new@example.com", phone: "1234567890", note: "Updated note", linkedinURL: nil, isFavorite: false)
        let result = await service.updateCandidate(candidate: candidateToUpdate)
        switch result {
        case .success:
            XCTFail("Expected failure due to unprocessable entity")
        case .failure(let error):
            if case VitesseRHError.server(let srvError) = error {
                XCTAssertEqual(srvError.localizedDescription, ServerError.unprocessableEntity.localizedDescription)
            } else {
                XCTFail("Expected server unprocessable entity error, got: \(error)")
            }
        }
    }
    
    // MARK: - favoriteToggle Tests
    
    func testFavoriteToggleWithValidIdShouldReturnUpdatedCandidate() async {
        let candidateDetailJSON = """
        {
            "id": "1",
            "firstName": "Alice",
            "lastName": "Smith",
            "email": "alice@example.com",
            "phone": "1234567890",
            "note": null,
            "linkedinURL": null,
            "isFavorite": true
        }
        """
        let data = candidateDetailJSON.data(using: .utf8)!
        let mockSession = makeMockSession(data: data, statusCode: 200, path: .favorite("1"))
        let service = makeService(withSession: mockSession)
        
        let result = await service.favoriteToggle(forId: "1")
        switch result {
        case .success(let candidate):
            XCTAssertTrue(candidate.isFavorite)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testFavoriteToggleWithServerErrorShouldFailWithInternalServerError() async {
        let data = Data()
        let mockSession = makeMockSession(data: data, statusCode: 500, path: .favorite("1"))
        let service = makeService(withSession: mockSession)
        
        let result = await service.favoriteToggle(forId: "1")
        switch result {
        case .success:
            XCTFail("Expected failure due to internal server error")
        case .failure(let error):
            if case VitesseRHError.server(let srvError) = error {
                XCTAssertEqual(srvError.localizedDescription, ServerError.internalServerError.localizedDescription)
            } else {
                XCTFail("Expected server internal error, got: \(error)")
            }
        }
    }
    
    // MARK: - deleteCandidate Tests
    
    func testDeleteCandidateWithValidIdShouldReturnSuccess() async {
        let data = Data()
        let mockSession = makeMockSession(data: data, statusCode: 200, path: .candidate("1"))
        let service = makeService(withSession: mockSession)
        
        let result = await service.deleteCandidate(withId: "1")
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testDeleteCandidateWithNonexistentIdShouldFailWithNotFoundError() async {
        let data = Data()
        let mockSession = makeMockSession(data: data, statusCode: 404, path: .candidate("1"))
        let service = makeService(withSession: mockSession)
        
        let result = await service.deleteCandidate(withId: "1")
        switch result {
        case .success:
            XCTFail("Expected failure due to not found")
        case .failure(let error):
            if case VitesseRHError.server(let srvError) = error {
                XCTAssertEqual(srvError.localizedDescription, ServerError.notFound.localizedDescription)
            } else {
                XCTFail("Expected server not found error, got: \(error)")
            }
        }
    }
    
    // MARK: - logIn Tests
    
    func testLogInWithValidCredentialsShouldReturnAuthenticationResponse() async {
        guard let data = loadJSONData(filename: "Authentication") else { return }
        let mockSession = makeMockSession(data: data, statusCode: 200, path: .auth)
        let service = makeService(withSession: mockSession)
        
        let result = await service.logIn(withEmail: "test@example.com", andPassword: "password")
        switch result {
        case .success(let authResponse):
            XCTAssertEqual(authResponse.token, "mock-token")
            XCTAssertEqual(authResponse.isAdmin, false)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testLogInWithInvalidCredentialsShouldFailWithUnauthorizedError() async {
        let data = Data()
        let mockSession = makeMockSession(data: data, statusCode: 401, path: .auth)
        let service = makeService(withSession: mockSession)
        
        let result = await service.logIn(withEmail: "wrong@example.com", andPassword: "wrongpassword")
        switch result {
        case .success:
            XCTFail("Expected failure due to unauthorized")
        case .failure(let error):
            if case VitesseRHError.auth(let authError) = error {
                XCTAssertEqual(authError.localizedDescription, AuthError.invalidMailOrPassword.localizedDescription)
            } else {
                XCTFail("Expected auth error invalidMailOrPassword, got: \(error)")
            }
        }
    }
    
    // MARK: - register Tests
    
    func testRegisterWithValidDataShouldReturnSuccess() async {
        let data = Data()
        let mockSession = makeMockSession(data: data, statusCode: 200, path: .register)
        let service = makeService(withSession: mockSession)
        
        let result = await service.register(mail: "new@example.com", password: "password", firstName: "New", lastName: "User")
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testRegisterWithInvalidDataShouldFailWithInvalidParametersError() async {
        let data = Data()
        let mockSession = makeMockSession(data: data, statusCode: 400, path: .register)
        let service = makeService(withSession: mockSession)
        
        let result = await service.register(mail: "new@example.com", password: "password", firstName: "New", lastName: "User")
        switch result {
        case .success:
            XCTFail("Expected failure due to invalid parameters")
        case .failure(let error):
            if case VitesseRHError.network(let netError) = error {
                XCTAssertEqual(netError.localizedDescription, NetworkError.invalidParameters.localizedDescription)
            } else {
                XCTFail("Expected network invalidParameters error, got: \(error)")
            }
        }
    }
}
