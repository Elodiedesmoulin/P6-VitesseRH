//
//  VitesseRHError.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidParameters
    case networkIssue
    case offline
    case sslError
    case timeout
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidParameters:
            return "Invalid parameters."
        case .networkIssue:
            return "Network error. Please check your internet connection."
        case .offline:
            return "It seems you are offline. Check your internet connection."
        case .sslError:
            return "A problem occurred with the SSL certificate."
        case .timeout:
            return "The request timed out. Please try again."
        case .unknown:
            return "An unknown network error occurred."
        }
    }
}


enum ServerError: Error {
    case invalidResponse
    case internalServerError
    case notFound
    case conflict
    case unprocessableEntity
    case tooManyRequests
    case serviceUnavailable
    case unknown
}

extension ServerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response."
        case .internalServerError:
            return "Server error. Please try again later."
        case .notFound:
            return "The requested resource was not found (404)."
        case .conflict:
            return "Conflict (409). A similar resource may already exist."
        case .unprocessableEntity:
            return "Unprocessable entity (422)."
        case .tooManyRequests:
            return "Too many requests. Please wait before trying again."
        case .serviceUnavailable:
            return "The service is unavailable (503). Please try again later."
        case .unknown:
            return "An unknown server error occurred."
        }
    }
}


enum AuthError: Error {
    case invalidMailOrPassword
    case invalidAuthentication
    case userAlreadyExists
    case permissionDenied
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidMailOrPassword:
            return "Invalid email or password."
        case .invalidAuthentication:
            return "Authentication failed, token not found or incorrect."
        case .userAlreadyExists:
            return "An account with this email already exists."
        case .permissionDenied:
            return "You do not have permission to perform this action."
        }
    }
}


enum ValidationError: Error {
    case emptyTextField
    case invalidEmail
    case emptyEmail
    case invalidPhone
    case invalidName
    case passwordMismatch
    case emptyPassword
    case invalidPassword
    case invalidLinkedInURL
    case unknown
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyTextField:
            return "This field must not be empty."
        case .invalidEmail:
            return "Invalid email format."
        case  .emptyEmail:
            return "Email must not be empty."
        case .invalidPhone:
            return "Invalid phone number format."
        case .invalidName:
            return "First name and last name must contain at least 3 characters."
        case .passwordMismatch:
            return "Passwords do not match. Please ensure both passwords are the same."
        case .emptyPassword:
            return "Password must not be empty."
        case .invalidPassword:
            return "Password must contain at least 6 characters."
        case .invalidLinkedInURL:
            return "The LinkedIn URL provided is invalid. Please check the URL format."
        case .unknown:
            return "A validation error occurred."
        }
    }
}

// MARK: - Global Error

enum VitesseRHError: Error, Identifiable {
    var id: String { String(describing: self) }
    
    case validation(ValidationError)
    case auth(AuthError)
    case network(NetworkError)
    case server(ServerError)
    
    case candidateCreationFailed
    case favoriteToggleFailed
    
    case unknown
}

extension VitesseRHError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .validation(let valError):
            return valError.localizedDescription
        case .auth(let authError):
            return authError.localizedDescription
        case .network(let netError):
            return netError.localizedDescription
        case .server(let srvError):
            return srvError.localizedDescription
            
        case .candidateCreationFailed:
            return "Failed to create candidate, please try again."
        case .favoriteToggleFailed:
            return "Failed to update favorite status, please try again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
    
    var title: String {
        return "Sorry, a problem occurred!"
    }
}
