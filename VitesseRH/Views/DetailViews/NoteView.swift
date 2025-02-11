//
//  NoteView.swift
//  VitesseRH
//
//  Created by Elo on 17/01/2025.
//

import SwiftUI

struct NoteView: View {
    let candidate: Candidate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Note")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            Text(candidate.note ?? "Not provided")
                .font(.body)
                .foregroundColor(.black)
                .padding(8)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)

        }
        .padding(.horizontal)
    }
}

