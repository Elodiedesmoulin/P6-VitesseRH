//
//  APIServiceTests.swift
//  VitesseRHTests
//
//  Created by Elo on 28/02/2025.
//

import XCTest
@testable import VitesseRH

import XCTest
@testable import VitesseRH

final class APIServiceTests: XCTestCase {
    
    var apiService: APIService!
    var mockSession: MockSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockSession()
        apiService = APIService(session: mockSession)
        AuthenticationManager.shared.saveAuthData(AuthenticationResponse(token: "token", isAdmin: false))
    }
    
    override func tearDown() {
        apiService = nil
        mockSession = nil
        AuthenticationManager.shared.deleteAuthData()
        super.tearDown()
    }
    
    func testExecuteRequestFailsForAuthWithoutToken() async {
        AuthenticationManager.shared.deleteAuthData()
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.auth(let authError) = error {
                XCTAssertEqual(authError.localizedDescription, AuthError.invalidAuthentication.localizedDescription)
            } else {
                XCTFail("Expected invalid authentication error, got: \(error)")
            }
        case .success:
            XCTFail("Request should have failed due to missing token.")
        }
    }
    
    func testExecuteRequestSuccess200() async {
        let testData = "Test".data(using: .utf8)!
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSession.dataTaskHandler = { request, delegate in
            return (testData, httpResponse)
        }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .success(let data):
            XCTAssertEqual(data, testData)
        case .failure(let error):
            XCTFail("Request should have succeeded, received error: \(error)")
        }
    }
    
    func testExecuteRequestMapping400() async {
        let testData = Data()
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
        mockSession.dataTaskHandler = { request, delegate in
            return (testData, httpResponse)
        }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.network(let netError) = error {
                XCTAssertEqual(netError.localizedDescription, NetworkError.invalidParameters.localizedDescription)
            } else {
                XCTFail("Expected invalidParameters error, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for HTTP code 400")
        }
    }
    
    func testExecuteRequestMapping401() async {
        let testData = Data()
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
        mockSession.dataTaskHandler = { request, delegate in
            return (testData, httpResponse)
        }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.auth(let authError) = error {
                XCTAssertEqual(authError.localizedDescription, AuthError.invalidMailOrPassword.localizedDescription)
            } else {
                XCTFail("Expected invalidMailOrPassword error, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for HTTP code 401")
        }
    }
    
    func testExecuteRequestMapping500() async {
        let testData = Data()
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
        mockSession.dataTaskHandler = { request, delegate in
            return (testData, httpResponse)
        }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.server(let serverError) = error {
                XCTAssertEqual(serverError.localizedDescription, ServerError.internalServerError.localizedDescription)
            } else {
                XCTFail("Expected internalServerError, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for HTTP code 500")
        }
    }
    
    func testExecuteRequestMapping422() async {
        let testData = Data()
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .post, url: url, parameters: nil, requiresAuth: true)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 422, httpVersion: nil, headerFields: nil)!
        mockSession.dataTaskHandler = { request, delegate in return (testData, httpResponse) }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.server(let serverError) = error {
                XCTAssertEqual(serverError.localizedDescription, ServerError.unprocessableEntity.localizedDescription)
            } else {
                XCTFail("Expected unprocessableEntity error, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for HTTP code 422")
        }
    }
    
    func testExecuteRequestMapping429() async {
        let testData = Data()
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 429, httpVersion: nil, headerFields: nil)!
        mockSession.dataTaskHandler = { request, delegate in return (testData, httpResponse) }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.server(let serverError) = error {
                XCTAssertEqual(serverError.localizedDescription, ServerError.tooManyRequests.localizedDescription)
            } else {
                XCTFail("Expected tooManyRequests error, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for HTTP code 429")
        }
    }
    
    func testExecuteRequestMapping503() async {
        let testData = Data()
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 503, httpVersion: nil, headerFields: nil)!
        mockSession.dataTaskHandler = { request, delegate in return (testData, httpResponse) }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.server(let serverError) = error {
                XCTAssertEqual(serverError.localizedDescription, ServerError.serviceUnavailable.localizedDescription)
            } else {
                XCTFail("Expected serviceUnavailable error, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for HTTP code 503")
        }
    }
    
    func testExecuteRequestMappingDefault() async {
        let testData = Data()
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 418, httpVersion: nil, headerFields: nil)!
        mockSession.dataTaskHandler = { request, delegate in return (testData, httpResponse) }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.server(let serverError) = error {
                XCTAssertEqual(serverError.localizedDescription, ServerError.invalidResponse.localizedDescription)
            } else {
                XCTFail("Expected invalidResponse error, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for an unknown HTTP code")
        }
    }
    
    func testExecuteRequestNonHTTPResponse() async {
        let testData = Data()
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        mockSession.dataTaskHandler = { request, delegate in return (testData, response) }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.network(let netError) = error {
                XCTAssertEqual(netError.localizedDescription, NetworkError.networkIssue.localizedDescription)
            } else {
                XCTFail("Expected networkIssue error for non-HTTP response, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for a non-HTTP response")
        }
    }
    
    func testExecuteRequestNotConnectedError() async {
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let notConnectedError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        mockSession.dataTaskHandler = { request, delegate in throw notConnectedError }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.network(let netError) = error {
                XCTAssertEqual(netError.localizedDescription, NetworkError.offline.localizedDescription)
            } else {
                XCTFail("Expected offline error, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for NSURLErrorNotConnectedToInternet")
        }
    }
    
    func testExecuteRequestTimedOutError() async {
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let timeoutError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
        mockSession.dataTaskHandler = { request, delegate in throw timeoutError }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.network(let netError) = error {
                XCTAssertEqual(netError.localizedDescription, NetworkError.timeout.localizedDescription)
            } else {
                XCTFail("Expected timeout error, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for NSURLErrorTimedOut")
        }
    }
    
    func testExecuteRequestSSLError() async {
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .get, url: url, parameters: nil, requiresAuth: true)
        let sslError = NSError(domain: NSURLErrorDomain, code: NSURLErrorSecureConnectionFailed, userInfo: nil)
        mockSession.dataTaskHandler = { request, delegate in throw sslError }
        let result = await apiService.executeRequest(config: config)
        switch result {
        case .failure(let error):
            if case VitesseRHError.network(let netError) = error {
                XCTAssertEqual(netError.localizedDescription, NetworkError.sslError.localizedDescription)
            } else {
                XCTFail("Expected sslError, got: \(error)")
            }
        case .success:
            XCTFail("Test should fail for NSURLErrorSecureConnectionFailed")
        }
    }

    
    func testBuildRequestSetsHttpBodyAndHeaders() async {
        AuthenticationManager.shared.saveAuthData(AuthenticationResponse(token: "myToken", isAdmin: false))
        let params: [String: AnyHashable] = ["key": "value"]
        let url = URL(string: "https://example.com")!
        let config = APIService.RequestConfig(method: .post, url: url, parameters: params, requiresAuth: true)
        var capturedRequest: URLRequest?
        mockSession.dataTaskHandler = { request, delegate in
            capturedRequest = request
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return ("{}".data(using: .utf8)!, httpResponse)
        }
        _ = await apiService.executeRequest(config: config)
        XCTAssertNotNil(capturedRequest, "Request should be built and passed to session")
        if let request = capturedRequest {
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer myToken")
            if let bodyData = request.httpBody,
               let jsonObject = try? JSONSerialization.jsonObject(with: bodyData) as? [String: Any] {
                XCTAssertEqual(jsonObject["key"] as? String, "value")
            } else {
                XCTFail("httpBody should contain valid JSON data")
            }
        }
    }
}
