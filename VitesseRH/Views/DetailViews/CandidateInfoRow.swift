//
//  CandidateInfoRow.swift
//  VitesseRH
//
//  Created by Elo on 17/01/2025.
//

import SwiftUI

struct CandidateInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("", text: .constant(value))
                .font( .body)
                .foregroundColor(.black)
                .padding(.vertical, 8)
                .disabled(true)
                .frame(height: 30)
        }
    }
}
