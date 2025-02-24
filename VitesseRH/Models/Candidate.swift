//
//  Candidate.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

struct Candidate: Codable, Identifiable, Hashable, Equatable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var note: String?
    var linkedinURL: String?
    var isFavorite: Bool
}

extension Candidate {
    var parameters: [String: AnyHashable] {
        [
            "email": email,
            "note": note ?? "",
            "linkedinURL": linkedinURL ?? "",
            "firstName": firstName,
            "lastName": lastName,
            "phone": phone
        ]
    }
}
