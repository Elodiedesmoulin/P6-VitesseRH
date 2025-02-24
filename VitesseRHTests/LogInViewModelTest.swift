//
//  LogInViewModelTest.swift
//  VitesseRHTests
//
//  Created by Elo on 20/01/2025.
//

import XCTest
import Combine

@testable import VitesseRH

final class LoginViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testLoginValidationFailsEmptyEmail() async {
        let mockAuthService = MockAuthenticationService()
        let viewModel = LoginViewModel(authService: mockAuthService) { }
        viewModel.email = ""
        viewModel.password = "validPassword"
        
        viewModel.signIn()
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertEqual(viewModel.errorMessage, VitesseRHError.validation(.emptyEmail).localizedDescription)
    }
    
    func testLoginValidationFailsInvalidEmail() async {
        let mockAuthService = MockAuthenticationService()
        let viewModel = LoginViewModel(authService: mockAuthService) { }
        viewModel.email = "invalid-email"
        viewModel.password = "validPassword"
        
        viewModel.signIn()
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertEqual(viewModel.errorMessage, VitesseRHError.validation(.invalidEmail).localizedDescription)
    }
    
    func testLoginValidationFailsEmptyPassword() async {
        let mockAuthService = MockAuthenticationService()
        let viewModel = LoginViewModel(authService: mockAuthService) { }
        viewModel.email = "admin@vitesse.com"
        viewModel.password = ""
        
        viewModel.signIn()
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertEqual(viewModel.errorMessage, VitesseRHError.validation(.emptyPassword).localizedDescription)
    }
    
    func testLoginValidationFailsShortPassword() async {
        let mockAuthService = MockAuthenticationService()
        let viewModel = LoginViewModel(authService: mockAuthService) { }
        viewModel.email = "admin@vitesse.com"
        viewModel.password = "123"
        
        viewModel.signIn()
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertEqual(viewModel.errorMessage, VitesseRHError.validation(.invalidPassword).localizedDescription)
    }
    
    func testLoginServiceFailure() async {
        let logInExpectation = XCTestExpectation(description: #function)
        
        let mockAuthService = MockAuthenticationService()
        let error = VitesseRHError.auth(.invalidMailOrPassword)
        mockAuthService.logInResult = .failure(error)
        
        let viewModel = LoginViewModel(authService: mockAuthService) { }
        viewModel.email = "admin@vitesse.com"
        viewModel.password = "wrongPassword"
        
        viewModel.signIn()
        viewModel.$errorMessage
            .dropFirst()
            .sink { _ in logInExpectation.fulfill() }
            .store(in: &cancellables)

        await fulfillment(of: [logInExpectation], timeout: 1)
        XCTAssertEqual(viewModel.errorMessage, error.localizedDescription)
    }
}

