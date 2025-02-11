//
//  CandidateDetailHeader.swift
//  VitesseRH
//
//  Created by Elo on 17/01/2025.
//

import SwiftUI

struct CandidateDetailHeader: View {
    @Binding var candidate: Candidate
    let toggleFavorite: () -> Void
    var isAdmin: Bool
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(candidate.firstName) \(candidate.lastName)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Spacer()
            
            if isAdmin {
                Button(action: {
                    candidate.isFavorite.toggle()
                    toggleFavorite()
                }) {
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
                        .foregroundColor(candidate.isFavorite ? .yellow : .gray)
                }
            } else {
                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
                    .foregroundColor(candidate.isFavorite ? .yellow : .gray)
                    .opacity(0.5)
            }
        }
        .padding(.bottom, 15)
    }
}
