//
//  RegisterViewModelTests.swift
//  VitesseRHTests
//
//  Created by Elo on 14/02/2025.
//

import XCTest
import Combine

@testable import VitesseRH

final class RegisterViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testRegisterValidationFailsEmptyEmail() async {
        let mockService = MockVitesseRHService()
        let viewModel = RegisterViewModel(service: mockService)
        viewModel.email = ""
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        viewModel.password = "password"
        viewModel.confirmPassword = "password"
        
        viewModel.register()
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertEqual(viewModel.errorMessage?.localizedDescription, VitesseRHError.validation(.emptyEmail).localizedDescription)
    }
    
    func testRegisterValidationFailsEmptyPassword() async {
        let mockService = MockVitesseRHService()
        let viewModel = RegisterViewModel(service: mockService)
        viewModel.email = "john@example.com"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        viewModel.password = ""
        viewModel.confirmPassword = ""
        
        viewModel.register()
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertEqual(viewModel.errorMessage?.localizedDescription, VitesseRHError.validation(.emptyPassword).localizedDescription)
    }
    
    func testRegisterValidationFailsPasswordMismatch() async {
        let mockService = MockVitesseRHService()
        let viewModel = RegisterViewModel(service: mockService)
        viewModel.email = "john@example.com"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        viewModel.password = "password1"
        viewModel.confirmPassword = "password2"
        
        viewModel.register()
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertEqual(viewModel.errorMessage?.localizedDescription, VitesseRHError.validation(.passwordMismatch).localizedDescription)
    }
    
    func testRegisterValidationFailsInvalidEmail() async {
        let mockService = MockVitesseRHService()
        let viewModel = RegisterViewModel(service: mockService)
        viewModel.email = "invalid-email"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        viewModel.password = "password"
        viewModel.confirmPassword = "password"
        
        viewModel.register()
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertEqual(viewModel.errorMessage?.localizedDescription, VitesseRHError.validation(.invalidEmail).localizedDescription)
    }
    
    func testRegisterValidationFailsEmptyName() async {
        let mockService = MockVitesseRHService()
        let viewModel = RegisterViewModel(service: mockService)
        viewModel.email = "john@example.com"
        viewModel.firstName = ""
        viewModel.lastName = ""
        viewModel.password = "password"
        viewModel.confirmPassword = "password"
        
        viewModel.register()
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertEqual(viewModel.errorMessage?.localizedDescription, VitesseRHError.validation(.invalidName).localizedDescription)
    }
    
    func testRegisterSuccess() async {
        let registerExpectation = XCTestExpectation(description: #function)
        
        let mockService = MockVitesseRHService()
        mockService.registerResult = .success(true)
        
        let viewModel = RegisterViewModel(service: mockService)
        viewModel.email = "new@example.com"
        viewModel.firstName = "New"
        viewModel.lastName = "User"
        viewModel.password = "password"
        viewModel.confirmPassword = "password"
        
        viewModel.$isRegistered
            .dropFirst()
            .sink { registered in
                if registered { registerExpectation.fulfill() }
            }
            .store(in: &cancellables)

        viewModel.register()
        await fulfillment(of: [registerExpectation], timeout: 1)
        
        XCTAssertTrue(viewModel.isRegistered)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testRegisterFailureDueToServiceError() async {
        let errorExpectation = XCTestExpectation(description: #function)
        
        let mockService = MockVitesseRHService()
        let error = VitesseRHError.network(.invalidParameters)
        mockService.registerResult = .failure(error)
        
        let viewModel = RegisterViewModel(service: mockService)
        viewModel.email = "new@example.com"
        viewModel.firstName = "New"
        viewModel.lastName = "User"
        viewModel.password = "password"
        viewModel.confirmPassword = "password"
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { _ in errorExpectation.fulfill() }
            .store(in: &cancellables)

        viewModel.register()
        await fulfillment(of: [errorExpectation], timeout: 1)
        
        XCTAssertEqual(viewModel.errorMessage?.localizedDescription, error.localizedDescription)
        XCTAssertFalse(viewModel.isRegistered)
    }
}
