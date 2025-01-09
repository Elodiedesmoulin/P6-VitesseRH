//
//  Candidate.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

struct Candidate: Codable, Identifiable, Hashable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var note: String?
    var linkedinURL: String?
    var isFavorite: Bool
    
    func asDictionary() throws -> [String: Any] {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        }
}
