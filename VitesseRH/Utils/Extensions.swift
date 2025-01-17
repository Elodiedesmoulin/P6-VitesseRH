//
//  Extensions.swift
//  VitesseRH
//
//  Created by Elo on 17/01/2025.
//

import Foundation
import SwiftUI

extension URLSession: SessionProtocol {}

extension UIApplication {
    func endEditing() {
        guard let windowScene = connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.endEditing(true)
    }
}

//extension Error {
//    func userFriendlyMessage() -> String {
//        if let error = self as? VitesseRHError {
//            return error.localizedDescription
//        }
//        return "An unknown error occurred. Please try again later."
//    }
//}


