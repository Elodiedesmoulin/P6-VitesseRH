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
    let isLarge: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            TextField("", text: .constant(value))
                .font(isLarge ? .title2 : .body)
                .foregroundColor(.black)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(Color.white)
                )
                .frame(height: isLarge ? 40 : 30)
        }
    }
}

//#Preview {
//    CandidateInfoRow()
//}
