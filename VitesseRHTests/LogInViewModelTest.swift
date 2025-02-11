//
//  LogInViewModelTest.swift
//  VitesseRHTests
//
//  Created by Elo on 20/01/2025.
//

import XCTest
@testable import VitesseRH

//class LoginViewModelTest: XCTestCase {
//    
//    private var viewModel: LoginViewModel!
//    private var mockSession: MockSession!
//    
//    override func setUp() {
//        super.setUp()
//        mockSession = MockSession()
//        viewModel = LoginViewModel()
//        viewModel.service = VitesseRHService(session: mockSession)
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        mockSession = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Tests
//
//    func testLoginWithInvalidEmail() async {
//        await testLoginWithInvalidCredential(email: "invalidEmail", password: "Feu2stjean.", expectedError: VitesseRHError.invalidParameters.localizedDescription)
//    }
//
//    func testLoginWithInvalidPassword() async {
//        await testLoginWithInvalidCredential(email: "elodie.dsmln@icloud.com", password: "123", expectedError: VitesseRHError.invalidParameters.localizedDescription)
//    }
//
//    func testLoginWithValidCredentialsButAuthenticationError() async {
//        await testLoginWithValidCredentials(
//            email: "valid@example.com",
//            password: "validPassword123",
//            statusCode: 401,
//            expectedError: VitesseRHError.invalidAuthentication.localizedDescription
//        )
//    }
//
//    func testLoginWithValidCredentials() async {
//        await testLoginWithValidCredentials(
//            email: "valid@example.com",
//            password: "validPassword123",
//            statusCode: 200,
//            expectedToken: "validToken"
//        )
//    }
//
//    func testLoginWithNetworkError() async {
//        await testLoginWithURLError(errorCode: .notConnectedToInternet, expectedError: VitesseRHError.networkError.localizedDescription)
//    }
//
//    func testLoginWithTimeoutError() async {
//        await testLoginWithURLError(errorCode: .timedOut, expectedError: VitesseRHError.timeout.localizedDescription)
//    }
//
//    func testLogout() {
//        viewModel.token = "validToken"
//        viewModel.isAuthenticated = true
//        viewModel.email = "valid@example.com"
//        viewModel.password = "validPassword123"
//        
//        viewModel.logout()
//        
//        XCTAssertNil(viewModel.token)
//        XCTAssertFalse(viewModel.isAuthenticated)
//        XCTAssertEqual(viewModel.email, "")
//        XCTAssertEqual(viewModel.password, "")
//        XCTAssertNil(viewModel.loginMessage)
//    }
//
//    func testIsEmailValid() {
//        XCTAssertTrue(viewModel.isEmailValid("valid@example.com"))
//        XCTAssertFalse(viewModel.isEmailValid("invalidEmail"))
//    }
//
//    func testIsPasswordValid() {
//        XCTAssertTrue(viewModel.isPasswordValid("validPassword123"))
//        XCTAssertFalse(viewModel.isPasswordValid("123"))
//    }
//
//    // MARK: - Helper Methods
//    
//    private func testLoginWithInvalidCredential(email: String, password: String, expectedError: String) async {
//        viewModel.email = email
//        viewModel.password = password
//        
//        viewModel.login()
//        
//        XCTAssertFalse(viewModel.isAuthenticated)
//        XCTAssertEqual(viewModel.loginMessage, expectedError)
//    }
//    
//    private func testLoginWithValidCredentials(email: String, password: String, statusCode: Int, expectedToken: String? = nil, expectedError: String? = nil) async {
//        let mockResponse = AuthenticationResponse(token: expectedToken ?? "", isAdmin: false)
//        let mockData = try! JSONEncoder().encode(mockResponse)
//        mockSession.nextData = mockData
//        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
//        
//        viewModel.login()
//        
//        if let expectedError = expectedError {
//            XCTAssertFalse(viewModel.isAuthenticated)
//            XCTAssertEqual(viewModel.loginMessage, expectedError)
//        } else {
//            XCTAssertTrue(viewModel.isAuthenticated)
//            XCTAssertEqual(viewModel.token, expectedToken)
//            XCTAssertNil(viewModel.loginMessage)
//        }
//    }
//    
//    private func testLoginWithURLError(errorCode: URLError.Code, expectedError: String) async {
//        let networkError = URLError(errorCode)
//        mockSession.nextError = networkError
//        
//        viewModel.email = "valid@example.com"
//        viewModel.password = "validPassword123"
//        
//        viewModel.login()
//        
//        XCTAssertFalse(viewModel.isAuthenticated)
//        XCTAssertEqual(viewModel.loginMessage, expectedError)
//    }
//}
