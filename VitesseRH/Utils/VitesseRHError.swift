//
//  VitesseRHError.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

enum VitesseRHError: LocalizedError {
    case invalidEmail
    case invalidPhone
    case invalidName
    case invalidPassword
    case invalidUrl
    case invalidParameters
    case invalidAuthentication
    case invalidResponse
    case networkError
    case serverError
    case timeout
    case userAlreadyExists
    case permissionDenied
    case candidateCreationFailed
    case favoriteToggleFailed
    case passwordMismatch
    case invalidLinkedInURL
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email format."
        case .invalidPhone:
            return "Invalid phone number format."
        case .invalidName:
            return "First name and last name must contain at least 3 characters."
        case .invalidPassword:
            return "Invalid password. It must be at least 6 characters"
        case .invalidUrl:
            return "Invalid URL."
        case .invalidParameters:
            return "Invalid parameters."
        case .invalidAuthentication:
            return "Authentication failed, token not found or incorrect."
        case .invalidResponse:
            return "Invalid server response."
        case .networkError:
            return "Network error. Please check your internet connection."
        case .serverError:
            return "Server error. Please try again later."
        case .timeout:
            return "The request timed out. Please try again."
        case .userAlreadyExists:
            return "An account with this email already exists."
        case .permissionDenied:
            return "You do not have permission to perform this action."
        case .candidateCreationFailed:
            return "Failed to create candidate, please try again."
        case .favoriteToggleFailed:
            return "Failed to update favorite status, please try again."
        case .passwordMismatch:
            return "Passwords do not match. Please ensure both passwords are the same."
        case .invalidLinkedInURL:
            return "The LinkedIn URL provided is invalid. Please check the URL format."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
