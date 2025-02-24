//
//  CreateCandidateViewModelTests.swift
//  VitesseRHTests
//
//  Created by Elo on 14/02/2025.
//

import XCTest
import Combine

@testable import VitesseRH

final class CreateCandidateViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testAddCandidateSuccess() async {
        let dismissExpectation = XCTestExpectation(description: #function)
        
        let mockService = MockVitesseRHService()
        let addedCandidate = Candidate(id: "3", firstName: "Test", lastName: "Candidate", email: "test@example.com", phone: "0000000000", note: "note", linkedinURL: "linkedin", isFavorite: false)
        mockService.addCandidateResult = .success(addedCandidate)
        
        let viewModel = CreateCandidateViewModel(service: mockService)
        viewModel.firstName = "Test"
        viewModel.lastName = "Candidate"
        viewModel.email = "test@example.com"
        viewModel.phone = "0000000000"
        viewModel.linkedinURL = "https://linkedin.com/in/test"
        viewModel.note = "note"
        
        viewModel.$dismissView
            .dropFirst()
            .sink { dismiss in
                if dismiss { dismissExpectation.fulfill() }
            }
            .store(in: &cancellables)
        
        viewModel.addCandidate()
        await fulfillment(of: [dismissExpectation], timeout: 1)
        
        XCTAssertTrue(viewModel.dismissView)
        XCTAssertEqual(viewModel.errorMessage, "")
    }
    
    func testAddCandidateFailureDueToValidation() async {
        let viewModel = CreateCandidateViewModel(service: MockVitesseRHService())
        viewModel.firstName = ""
        viewModel.lastName = ""
        viewModel.email = "invalid-email"
        
        viewModel.addCandidate()
        XCTAssertFalse(viewModel.isAdding)
        XCTAssertFalse(viewModel.dismissView)
        XCTAssertNotEqual(viewModel.errorMessage, "")
    }
    
    func testAddCandidateFailureDueToInvalidPhone() async {
        let viewModel = CreateCandidateViewModel(service: MockVitesseRHService())
        viewModel.firstName = "Test"
        viewModel.lastName = "Candidate"
        viewModel.email = "test@example.com"
        viewModel.phone = "123"  
        
        viewModel.addCandidate()
        XCTAssertFalse(viewModel.isAdding)
        XCTAssertFalse(viewModel.dismissView)
        XCTAssertEqual(viewModel.errorMessage, VitesseRHError.validation(.invalidPhone).localizedDescription)
    }
    
    func testAddCandidateFailureDueToInvalidLinkedInURL() async {
        let viewModel = CreateCandidateViewModel(service: MockVitesseRHService())
        viewModel.firstName = "Test"
        viewModel.lastName = "Candidate"
        viewModel.email = "test@example.com"
        viewModel.linkedinURL = "not-a-url"
        
        viewModel.addCandidate()
        XCTAssertFalse(viewModel.dismissView)
        XCTAssertEqual(viewModel.errorMessage, VitesseRHError.validation(.invalidLinkedInURL).localizedDescription)
    }
    

    
    func testDetailsHaveBeenEdited() {
        let viewModel = CreateCandidateViewModel(service: MockVitesseRHService())
        XCTAssertFalse(viewModel.isEdited)
        
        viewModel.firstName = "Test"
        XCTAssertTrue(viewModel.isEdited)
    }
}


