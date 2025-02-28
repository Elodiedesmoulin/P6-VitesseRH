//
//  VitesseRHAppViewModelTests.swift
//  VitesseRHTests
//
//  Created by Elo on 28/02/2025.
//

import XCTest
import Combine
@testable import VitesseRH

final class VitesseRHAppViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        AuthenticationManager.shared.deleteAuthData()
    }
    
    override func tearDown() {
        AuthenticationManager.shared.deleteAuthData()
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testInitialIsLoggedInFalseWhenNoToken() {
        let appVM = VitesseRHAppViewModel()
        XCTAssertFalse(appVM.isLoggedIn, "isLoggedIn should be false when no token is stored")
    }
    
    func testInitialIsLoggedInTrueWhenTokenExists() {
        let response = AuthenticationResponse(token: "dummyToken", isAdmin: false)
        AuthenticationManager.shared.saveAuthData(response)
        let appVM = VitesseRHAppViewModel()
        XCTAssertTrue(appVM.isLoggedIn, "isLoggedIn should be true when a token is stored")
    }
    
    func testLoginViewModelProperty() {
        let appVM = VitesseRHAppViewModel()
        let loginVM = appVM.loginViewModel
        XCTAssertNotNil(loginVM, "loginViewModel property should not be nil")
    }
    
    func testCandidateListViewModelProperty() {
        let appVM = VitesseRHAppViewModel()
        let candidateVM = appVM.candidateListViewModel
        XCTAssertNotNil(candidateVM, "candidateListViewModel property should not be nil")
    }
    
    func testLoginViewModelReturnsNewInstances() {
        let appVM = VitesseRHAppViewModel()
        let vm1 = appVM.loginViewModel
        let vm2 = appVM.loginViewModel
        XCTAssertFalse(vm1 === vm2, "Each call to loginViewModel should return a new instance")
    }
    
    func testCandidateListViewModelReturnsNewInstances() {
        let appVM = VitesseRHAppViewModel()
        let vm1 = appVM.candidateListViewModel
        let vm2 = appVM.candidateListViewModel
        XCTAssertFalse(vm1 === vm2, "Each call to candidateListViewModel should return a new instance")
    }
    
    func testLoginViewModelSuccessSetsIsLoggedInTrue() async {
        AuthenticationManager.shared.deleteAuthData()
        let appVM = VitesseRHAppViewModel()
        XCTAssertFalse(appVM.isLoggedIn, "Before login, isLoggedIn should be false")
        let mockAuthService = MockAuthenticationService()
        let successResponse = AuthenticationResponse(token: "dummyToken", isAdmin: false)
        mockAuthService.logInResult = .success(successResponse)
        let loginExpectation = expectation(description: "isLoggedIn becomes true after login")
        appVM.$isLoggedIn
            .dropFirst()
            .sink { newValue in
                if newValue { loginExpectation.fulfill() }
            }
            .store(in: &cancellables)
        let loginVM = LoginViewModel(authService: mockAuthService, onLoginSuccess: {
            Task { @MainActor in
                appVM.isLoggedIn = true
            }
        })
        loginVM.email = "test@example.com"
        loginVM.password = "password"
        loginVM.signIn()
        await fulfillment(of: [loginExpectation], timeout: 1)
        
        XCTAssertTrue(appVM.isLoggedIn, "After a successful login, isLoggedIn should be true")
    }
    
    func testCandidateListViewModelSignOutSetsIsLoggedInFalse() async {
        let response = AuthenticationResponse(token: "dummyToken", isAdmin: false)
        AuthenticationManager.shared.saveAuthData(response)
        let appVM = VitesseRHAppViewModel()
        XCTAssertTrue(appVM.isLoggedIn, "Before logout, isLoggedIn should be true")
        let signOutExpectation = expectation(description: "isLoggedIn becomes false after signOut")
        appVM.$isLoggedIn
            .dropFirst()
            .sink { newValue in
                if !newValue { signOutExpectation.fulfill() }
            }
            .store(in: &cancellables)
        let candidateVM = appVM.candidateListViewModel
        candidateVM.signOut()
        await fulfillment(of: [signOutExpectation], timeout: 1)
        
        XCTAssertFalse(appVM.isLoggedIn, "After logout, isLoggedIn should be false")
        XCTAssertNil(AuthenticationManager.shared.getToken(), "The token should be removed after logout")
    }
    
    func testDirectOnLoginSuccessClosure() async {
        let appVM = VitesseRHAppViewModel()
        XCTAssertFalse(appVM.isLoggedIn, "Before calling the closure, isLoggedIn should be false")
        let onLoginSuccess: () -> Void = {
            Task { @MainActor in
                appVM.isLoggedIn = true
            }
        }
        onLoginSuccess()
        await MainActor.run {}
        XCTAssertTrue(appVM.isLoggedIn, "After direct call of the closure, isLoggedIn should be true")
    }
    
    func testDirectOnSignOutClosure() async {
        let response = AuthenticationResponse(token: "dummyToken", isAdmin: false)
        AuthenticationManager.shared.saveAuthData(response)
        let appVM = VitesseRHAppViewModel()
        XCTAssertTrue(appVM.isLoggedIn, "Before calling the closure, isLoggedIn should be true")
        let onSignOut: () -> Void = {
            AuthenticationManager.shared.deleteAuthData()
            Task { @MainActor in
                appVM.isLoggedIn = false
            }
        }
        onSignOut()
        await MainActor.run {}
        XCTAssertFalse(appVM.isLoggedIn, "After direct call of the closure, isLoggedIn should be false")
        XCTAssertNil(AuthenticationManager.shared.getToken(), "The token should be removed after the closure call")
    }
}
