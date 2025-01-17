//
//  CandidateDetailInfo.swift
//  VitesseRH
//
//  Created by Elo on 17/01/2025.
//

import SwiftUI

struct CandidateDetailInfo: View {
    let candidate: Candidate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CandidateInfoRow(label: "Email", value: candidate.email, isLarge: false)
            CandidateInfoRow(label: "Phone", value: candidate.phone, isLarge: false)
            CandidateInfoRow(label: "LinkedIn", value: candidate.linkedinURL ?? "Not provided", isLarge: false)
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    CandidateDetailInfo()
//}
