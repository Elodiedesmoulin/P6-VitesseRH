//
//  DetailViewModelTests.swift
//  VitesseRHTests
//
//  Created by Elo on 14/02/2025.
//

import XCTest
import Combine
@testable import VitesseRH

final class DetailViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    func testToggleFavoriteSuccess() async {
        let expectation = XCTestExpectation(description: #function)

        let candidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
        let updatedCandidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: true)
        let mockService = MockVitesseRHService()
        mockService.favoriteToggleResult = .success(updatedCandidate)
        
        let viewModel = DetailViewModel(token: "dummy", candidate: candidate, isAdmin: false, service: mockService)
        
        viewModel.$candidate
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.toggleFavorite()
        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertTrue(viewModel.candidate.isFavorite)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testToggleFavoriteFailure() async {
        let expectation = XCTestExpectation(description: #function)

        let candidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
        let error = VitesseRHError.server(.internalServerError)
        let mockService = MockVitesseRHService()
        mockService.favoriteToggleResult = .failure(error)
        
        let viewModel = DetailViewModel(token: "dummy", candidate: candidate, isAdmin: false, service: mockService)
        
        viewModel.$candidate
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.toggleFavorite()
        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertFalse(viewModel.candidate.isFavorite)
        XCTAssertEqual(viewModel.errorMessage, error.localizedDescription)
    }
    
    func testFetchCandidateDetailsSuccess() async {
        let expectation = XCTestExpectation(description: #function)

        let candidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
        let updatedCandidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice_new@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
        let mockService = MockVitesseRHService()
        mockService.getCandidateResult = .success(updatedCandidate)
        
        let viewModel = DetailViewModel(token: "dummy", candidate: candidate, isAdmin: false, service: mockService)
        
        viewModel.$candidate
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCandidateDetails()
        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertEqual(viewModel.candidate.email, "alice_new@example.com")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchCandidateDetailsFailure() async {
        let expectation = XCTestExpectation(description: #function)

        let candidate = Candidate(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "1234567890", note: nil, linkedinURL: nil, isFavorite: false)
        let error = VitesseRHError.server(.notFound)
        let mockService = MockVitesseRHService()
        mockService.getCandidateResult = .failure(error)
        
        let viewModel = DetailViewModel(token: "dummy", candidate: candidate, isAdmin: false, service: mockService)
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCandidateDetails()
        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertEqual(viewModel.errorMessage, error.localizedDescription)
    }
}
