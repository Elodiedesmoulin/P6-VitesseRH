//
//  LogoView.swift
//  VitesseRH
//
//  Created by Elo on 09/01/2025.
//

import SwiftUI

struct LogoView: View {
    @State var width: CGFloat = 335
    @State var height: CGFloat = 100
    
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
