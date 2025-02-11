//
//  ApiClient.swift
//  VitesseRH
//
//  Created by Elo on 28/01/2025.
//

import Foundation

class ApiService {
    
    enum RequestMethod: String {
        case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
    }
    
    struct RequestConfig {
        let method: RequestMethod
        let url: URL
        let parameters: [String: AnyHashable]?
        let requiresAuth: Bool
    }
    
    private struct HeaderKey {
        static let authorization = "Authorization"
        static let bearer = "Bearer"
    }
    
    private var session: SessionProtocol
    
    init(session: SessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    @discardableResult
    func executeRequest(config: RequestConfig) async -> Result<Data, VitesseRHError> {
        var request = URLRequest(url: config.url)
        request.httpMethod = config.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let params = config.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params)
            } catch {
                return .failure(.network(.invalidParameters))
            }
        }
        
        if config.requiresAuth {
            guard let token = AuthenticationManager.shared.getToken() else {
                return .failure(.auth(.invalidAuthentication))
            }
            request.addValue("\(HeaderKey.bearer) \(token)", forHTTPHeaderField: HeaderKey.authorization)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.network(.networkIssue))
            }
            
            switch httpResponse.statusCode {
            case 200, 201, 204:
                return .success(data)
            case 400:
                return .failure(.network(.invalidParameters))
            case 401:
                return .failure(.auth(.invalidMailOrPassword))
            case 403:
                return .failure(.auth(.permissionDenied))
            case 404:
                return .failure(.server(.notFound))
            case 409:
                return .failure(.server(.conflict))
            case 422:
                return .failure(.server(.unprocessableEntity))
            case 429:
                return .failure(.server(.tooManyRequests))
            case 500:
                return .failure(.server(.internalServerError))
            case 503:
                return .failure(.server(.serviceUnavailable))
            default:
                return .failure(.server(.invalidResponse))
            }
        }
        catch let nsError as NSError {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                return .failure(.network(.offline))
            case NSURLErrorTimedOut:
                return .failure(.network(.timeout))
            case NSURLErrorSecureConnectionFailed,
                 NSURLErrorServerCertificateUntrusted,
                 NSURLErrorServerCertificateHasBadDate,
                 NSURLErrorServerCertificateNotYetValid:
                return .failure(.network(.sslError))
            default:
                return .failure(.network(.networkIssue))
            }
        }
        catch {
            return .failure(.unknown)
        }
    }
}

