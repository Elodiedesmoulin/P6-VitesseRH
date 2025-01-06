//
//  VitesseRHError.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

enum VitesseRHError: LocalizedError {
    case invalidUrl
    case invalidParameters
    case invalidAuthentication
    case invalidResponse
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL invalide."
        case .invalidParameters:
            return "Paramètres de requête incorrects."
        case .invalidAuthentication:
            return "Authentification échouée, token non trouvé ou incorrect."
        case .invalidResponse:
            return "Réponse du serveur non valide."
        case .unknown:
            return "Erreur inconnue"
        }
    }
}
