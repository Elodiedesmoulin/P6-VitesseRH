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
            CandidateInfoRow(label: "Email", value: candidate.email)
            CandidateInfoRow(label: "Phone", value: candidate.phone)
            CandidateInfoRow(label: "LinkedIn", value: candidate.linkedinURL ?? "Not provided")
        }
        .padding(.horizontal)
    }
}
