//
//  SessionProtocol.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

protocol SessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: SessionProtocol {}


