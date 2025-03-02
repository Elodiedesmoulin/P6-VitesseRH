//
//  EditingViewModelTests.swift
//  VitesseRHTests
//
//  Created by Elo on 14/02/2025.
//

import XCTest
import SwiftUI
@testable import VitesseRH

@MainActor
final class EditingViewModelTests: XCTestCase {
    
    func candidateFromJSON() throws -> Candidate {
        guard let data = loadJSONData(filename: "Candidates") else {
            XCTFail("Impossible de charger Candidates.json")
            throw NSError(domain: "Candidates", code: 0, userInfo: nil)
        }
        let candidates = try JSONDecoder().decode([Candidate].self, from: data)
        guard let candidate = candidates.first(where: { $0.id == "1" }) else {
            XCTFail("Aucun candidat avec l'id 1 trouvé dans le JSON")
            throw NSError(domain: "Candidates", code: 1, userInfo: nil)
        }
        return candidate
    }
    
    func testSaveChangesSuccess() async throws {
        var candidate = try candidateFromJSON()
        candidate.email = "alice@example.com"
        candidate.phone = "0123456789"
        candidate.linkedinURL = "https://linkedin.com/in/alice"
        
        let candidateBinding = Binding<Candidate>(
            get: { candidate },
            set: { candidate = $0 }
        )
        
        let mockService = MockVitesseRHService()
        mockService.updateCandidateResult = .success(candidate)
        
        let viewModel = EditingViewModel(candidate: candidateBinding, token: "dummy", candidateId: candidate.id, service: mockService)
        
        viewModel.$candidate.wrappedValue.email = "alice@example.com"
        viewModel.$candidate.wrappedValue.phone = "0123456789"
        viewModel.$candidate.wrappedValue.linkedinURL = "https://linkedin.com/in/alice"
        
        await viewModel.saveChanges()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(candidate.email, "alice@example.com")
    }
    
    func testSaveChangesFailureDueToInvalidEmail() async throws {
        var candidate = try candidateFromJSON()
        candidate.email = "invalid-email"
        
        let candidateBinding = Binding<Candidate>(
            get: { candidate },
            set: { candidate = $0 }
        )
        let mockService = MockVitesseRHService()
        let viewModel = EditingViewModel(candidate: candidateBinding, token: "dummy", candidateId: candidate.id, service: mockService)
        
        await viewModel.saveChanges()
        XCTAssertEqual(viewModel.errorMessage, VitesseRHError.validation(.invalidEmail).localizedDescription)
    }
    
    func testSaveChangesFailureDueToInvalidPhone() async throws {
        var candidate = try candidateFromJSON()
        candidate.phone = "invalid-phone"
        
        let candidateBinding = Binding<Candidate>(
            get: { candidate },
            set: { candidate = $0 }
        )
        let mockService = MockVitesseRHService()
        let viewModel = EditingViewModel(candidate: candidateBinding, token: "dummy", candidateId: candidate.id, service: mockService)
        
        await viewModel.saveChanges()
        XCTAssertEqual(viewModel.errorMessage, VitesseRHError.validation(.invalidPhone).localizedDescription)
    }
    
    func testSaveChangesFailureDueToInvalidLinkedInURL() async throws {
        var candidate = try candidateFromJSON()
        candidate.phone = "0123456789"
        candidate.linkedinURL = "not-a-url"
        
        let candidateBinding = Binding<Candidate>(
            get: { candidate },
            set: { candidate = $0 }
        )
        let mockService = MockVitesseRHService()
        let viewModel = EditingViewModel(candidate: candidateBinding, token: "dummy", candidateId: candidate.id, service: mockService)
        
        await viewModel.saveChanges()
        XCTAssertEqual(viewModel.errorMessage, VitesseRHError.validation(.invalidLinkedInURL).localizedDescription)
    }
    
    func testSaveChangesFailureDueToServiceError() async throws {
        var candidate = try candidateFromJSON()
        candidate.email = "alice@example.com"
        candidate.phone = "0123456789"
        candidate.linkedinURL = "https://linkedin.com/in/alice"
        
        let candidateBinding = Binding<Candidate>(
            get: { candidate },
            set: { candidate = $0 }
        )
        let mockService = MockVitesseRHService()
        let error = VitesseRHError.server(.internalServerError)
        mockService.updateCandidateResult = .failure(error)
        
        let viewModel = EditingViewModel(candidate: candidateBinding, token: "dummy", candidateId: candidate.id, service: mockService)
        await viewModel.saveChanges()
        XCTAssertEqual(viewModel.errorMessage, error.localizedDescription)
    }
}
