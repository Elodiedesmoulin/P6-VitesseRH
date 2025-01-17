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
        VStack(alignment: .leading) {
            HStack {
                Text("Note")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
                Spacer()
            }
            HStack {
                Text(candidate.note ?? "Not provided")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.body)
            }
            .padding(8)
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color.white)
            )
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    NoteView()
//}
