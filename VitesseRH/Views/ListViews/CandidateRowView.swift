//
//  CandidateRowView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct CandidateRowView: View {
    let candidate: Candidate
    let isInEditMode: Bool
    let isSelected: Bool
    let toggleSelection: () -> Void
    
    var body: some View {
        HStack {
            if isInEditMode {
                Button(action: toggleSelection) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.black)
                }
            }
            
            Text(candidate.firstName + " " + candidate.lastName)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                .foregroundColor(candidate.isFavorite ? .yellow : .gray)
        }
        .padding(.vertical, 5)
    }
}


