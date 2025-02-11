//
//  Extensions.swift
//  VitesseRH
//
//  Created by Elo on 17/01/2025.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.endEditing(true) }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidFrPhone() -> Bool {
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", "^(0\\d(?:[\\s.-]?\\d{2}){4}|0\\d{9})$")
        return phonePredicate.evaluate(with: self)
    }
    
    func formattedFRPhone() -> String {
        let digits = self.filter { $0.isNumber }
        let groups = stride(from: 0, to: digits.count, by: 2).map { index -> String in
            let start = digits.index(digits.startIndex, offsetBy: index)
            let end = digits.index(start, offsetBy: 2, limitedBy: digits.endIndex) ?? digits.endIndex
            return String(digits[start..<end])
        }
        return groups.joined(separator: " ")
    }
    
    mutating func applyFrPhonePattern() {
        self = self.formattedFRPhone()
    }
}


extension Notification.Name {
    static let needUpdate = Notification.Name("NeedUpdate")
}
