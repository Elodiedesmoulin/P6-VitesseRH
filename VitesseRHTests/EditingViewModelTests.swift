//
//  EditingViewModelTests.swift
//  VitesseRHTests
//
//  Created by Elo on 14/02/2025.
//

import XCTest
@testable import VitesseRH

@MainActor
final class EditingViewModelTests: XCTestCase {
    
    func testSaveChangesSuccess() async {
        let candidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "0123456789", note: "Note", linkedinURL: "https://linkedin.com/in/alice", isFavorite: false)
        let mockService = MockVitesseRHService()
        mockService.updateCandidateResult = .success(candidate)
        
        let viewModel = EditingViewModel(candidate: candidate, token: "dummy", candidateId: candidate.id, service: mockService)
        viewModel.candidate.email = "alice@example.com"
        viewModel.candidate.phone = "0123456789"
        viewModel.candidate.linkedinURL = "https://linkedin.com/in/alice"
        
        await viewModel.saveChanges()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.candidate.email, "alice@example.com")
    }
    
    func testSaveChangesFailureDueToInvalidEmail() async {
        let candidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "invalid-email", phone: "0123456789", note: "Note", linkedinURL: "https://linkedin.com/in/alice", isFavorite: false)
        let mockService = MockVitesseRHService()
        let viewModel = EditingViewModel(candidate: candidate, token: "dummy", candidateId: candidate.id, service: mockService)
        
        await viewModel.saveChanges()
        XCTAssertEqual(viewModel.errorMessage, "Invalid email format.")
    }
    
    func testSaveChangesFailureDueToInvalidPhone() async {
        let candidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "invalid-phone", note: "Note", linkedinURL: "https://linkedin.com/in/alice", isFavorite: false)
        let mockService = MockVitesseRHService()
        let viewModel = EditingViewModel(candidate: candidate, token: "dummy", candidateId: candidate.id, service: mockService)
        
        await viewModel.saveChanges()
        XCTAssertEqual(viewModel.errorMessage, "Invalid phone number format.")
    }
    
    func testSaveChangesFailureDueToInvalidLinkedInURL() async {
        let candidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "0123456789", note: "Note", linkedinURL: "not-a-url", isFavorite: false)
        let mockService = MockVitesseRHService()
        let viewModel = EditingViewModel(candidate: candidate, token: "dummy", candidateId: candidate.id, service: mockService)
        
        await viewModel.saveChanges()
        XCTAssertEqual(viewModel.errorMessage, "The LinkedIn URL provided is invalid. Please check the URL format.")
    }
    
    func testSaveChangesFailureDueToServiceError() async {
        let candidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "0123456789", note: "Note", linkedinURL: "https://linkedin.com/in/alice", isFavorite: false)
        let mockService = MockVitesseRHService()
        let error = VitesseRHError.server(.internalServerError)
        mockService.updateCandidateResult = .failure(error)
        
        let viewModel = EditingViewModel(candidate: candidate, token: "dummy", candidateId: candidate.id, service: mockService)
        await viewModel.saveChanges()
        XCTAssertEqual(viewModel.errorMessage, error.localizedDescription)
    }
}
