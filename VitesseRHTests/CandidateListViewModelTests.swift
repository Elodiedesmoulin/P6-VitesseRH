//
//  CandidateListViewModelTests.swift
//  VitesseRHTests
//
//  Created by Elo on 14/02/2025.
//

import XCTest
import Combine
@testable import VitesseRH

final class CandidateListViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testGetCandidatesSuccess() async throws {
        let loadExpectation = XCTestExpectation(description: #function)
        
        let mockService = MockVitesseRHService()
        guard let jsonData = loadJSONData(filename: "Candidates") else {
            XCTFail("Impossible to load Candidates.json")
            return
        }
        let decoder = JSONDecoder()
        let candidates = try decoder.decode([Candidate].self, from: jsonData)
        mockService.getCandidatesResult = .success(candidates)
        
        let viewModel = CandidateListViewModel(onSignOut: {}, service: mockService)
        
        viewModel.$allCandidates
            .dropFirst()
            .sink { _ in loadExpectation.fulfill() }
            .store(in: &cancellables)
        
        await fulfillment(of: [loadExpectation], timeout: 1)
        
        XCTAssertEqual(viewModel.allCandidates.count, 2)
        XCTAssertEqual(viewModel.candidates.count, 2)
    }
    
    func testGetCandidatesFailure() async {
        let errorExpectation = XCTestExpectation(description: #function)
        
        let mockService = MockVitesseRHService()
        let error = VitesseRHError.server(.internalServerError)
        mockService.getCandidatesResult = .failure(error)
        
        let viewModel = CandidateListViewModel(onSignOut: {}, service: mockService)
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { _ in errorExpectation.fulfill() }
            .store(in: &cancellables)
        
        await fulfillment(of: [errorExpectation], timeout: 1)
        
        XCTAssertTrue(viewModel.errorMessage.contains(error.title))
    }
    
    func testFilterCandidates() async throws {
        let loadExpectation = XCTestExpectation(description: #function)
        
        let mockService = MockVitesseRHService()
        guard let jsonData = loadJSONData(filename: "Candidates") else {
            XCTFail("Impossible to load Candidates.json")
            return
        }
        let candidates = try JSONDecoder().decode([Candidate].self, from: jsonData)
        mockService.getCandidatesResult = .success(candidates)
        
        let viewModel = CandidateListViewModel(onSignOut: {}, service: mockService)
        
        viewModel.$allCandidates
            .dropFirst()
            .sink { _ in loadExpectation.fulfill() }
            .store(in: &cancellables)
        
        await fulfillment(of: [loadExpectation], timeout: 1)
        
        viewModel.filter = (search: "Alice", favorites: false)
        XCTAssertEqual(viewModel.candidates.count, 1)
        XCTAssertEqual(viewModel.candidates.first?.firstName, "Alice")
        
        viewModel.filter = (search: "", favorites: true)
        XCTAssertEqual(viewModel.candidates.count, 1)
        XCTAssertEqual(viewModel.candidates.first?.firstName, "Bob")
    }
    
    func testEditModeToggleAndDeleteSelection() async throws {
        let updateExpectation = XCTestExpectation(description: #function)
        
        let mockService = MockVitesseRHService()
        guard let jsonData = loadJSONData(filename: "Candidates") else {
            XCTFail("Impossible to load Candidates.json")
            return
        }
        let candidates = try JSONDecoder().decode([Candidate].self, from: jsonData)
        mockService.getCandidatesResult = .success(candidates)
        mockService.deleteCandidateResult = .success(true)
        
        let viewModel = CandidateListViewModel(onSignOut: {}, service: mockService, autoFetch: false)
        
        let loadExpectation = XCTestExpectation(description: #function)
        viewModel.$allCandidates
            .dropFirst()
            .sink { _ in loadExpectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.getCandidates()
        
        await fulfillment(of: [loadExpectation], timeout: 1)
        
        XCTAssertEqual(viewModel.editMode, .inactive)
        viewModel.toggleEditMode()
        XCTAssertEqual(viewModel.editMode, .active)
        
        viewModel.selection = ["1"]
        viewModel.deleteSelection()
        
        viewModel.$allCandidates
            .dropFirst()
            .sink { _ in updateExpectation.fulfill() }
            .store(in: &cancellables)
        await fulfillment(of: [updateExpectation], timeout: 1)
        
        XCTAssertFalse(viewModel.allCandidates.contains { $0.id == "1" })
        XCTAssertTrue(viewModel.selection.isEmpty)
        XCTAssertEqual(viewModel.editMode, .inactive)
    }
    
    func testSignOut() async {
        let signOutExpectation = XCTestExpectation(description: #function)
        let viewModel = CandidateListViewModel(onSignOut: {
            signOutExpectation.fulfill()
        }, service: MockVitesseRHService())
        
        viewModel.signOut()
        await fulfillment(of: [signOutExpectation])
    }
    

    
    func testIsAdminComputedProperty() async {
        let authResponse = AuthenticationResponse(token: "dummy", isAdmin: true)
        AuthenticationManager.shared.saveAuthData(authResponse)
        
        let viewModel = CandidateListViewModel(onSignOut: {}, service: MockVitesseRHService())
        XCTAssertTrue(viewModel.isAdmin)
        
        AuthenticationManager.shared.deleteAuthData()
    }
    
    func testInEditModeComputedProperty() async {
        let viewModel = CandidateListViewModel(onSignOut: {}, service: MockVitesseRHService())
        viewModel.editMode = .active
        XCTAssertTrue(viewModel.inEditMode)
        viewModel.editMode = .inactive
        XCTAssertFalse(viewModel.inEditMode)
    }
    
    func testCreateCandidateSuccess() async {
        let updateExpectation = XCTestExpectation(description: #function)
        
        let mockService = MockVitesseRHService()
        let candidateToAdd = Candidate(id: "3", firstName: "Test", lastName: "Candidate", email: "test@example.com", phone: "0000000000", note: "note", linkedinURL: "linkedin", isFavorite: false)
        mockService.addCandidateResult = .success(candidateToAdd)
        
        let viewModel = CandidateListViewModel(onSignOut: {}, service: mockService)
        viewModel.createCandidate(firstName: "Test", lastName: "Candidate", email: "test@example.com", phone: "0000000000", linkedinURL: "linkedin", note: "note")
        
        viewModel.$allCandidates
            .dropFirst()
            .sink { _ in updateExpectation.fulfill() }
            .store(in: &cancellables)
        await fulfillment(of: [updateExpectation], timeout: 1)
        
        XCTAssertTrue(viewModel.allCandidates.contains { $0.id == "3" })
        XCTAssertEqual(viewModel.errorMessage, "Sorry, a problem occurred! An unknown error occurred.")
    }
    
    func testCreateCandidateFailure() async {
        let errorExpectation = XCTestExpectation(description: #function)
        
        let mockService = MockVitesseRHService()
        let error = VitesseRHError.server(.internalServerError)
        mockService.addCandidateResult = .failure(error)
        
        let viewModel = CandidateListViewModel(onSignOut: {}, service: mockService, autoFetch: false)
        
        viewModel.createCandidate(firstName: "Test", lastName: "Candidate", email: "test@example.com", phone: "0000000000", linkedinURL: "linkedin", note: "note")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { _ in errorExpectation.fulfill() }
            .store(in: &cancellables)
        await fulfillment(of: [errorExpectation], timeout: 1)
        
        XCTAssertEqual(viewModel.errorMessage, "\(error.title) \(error.localizedDescription)")
    }
    
    func testDeleteSelectionDoesNothingIfEmpty() async {
        let mockService = MockVitesseRHService()
        mockService.getCandidatesResult = .success([])
        
        let viewModel = CandidateListViewModel(onSignOut: {}, service: mockService)
        let loadExpectation = XCTestExpectation(description: #function)
        viewModel.$allCandidates
            .dropFirst()
            .sink { _ in loadExpectation.fulfill() }
            .store(in: &cancellables)
        await fulfillment(of: [loadExpectation], timeout: 1)
        
        viewModel.selection = []
        viewModel.deleteSelection()
        XCTAssertFalse(viewModel.inProgress)
    }
}
