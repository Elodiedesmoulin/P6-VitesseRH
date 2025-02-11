//
//  LogoView.swift
//  VitesseRH
//
//  Created by Elo on 09/01/2025.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 64)
            .padding(.bottom, 48)
            .padding(.top)
    }
}

#Preview {
    LogoView()
}
