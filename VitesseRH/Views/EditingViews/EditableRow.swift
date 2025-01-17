//
//  EditableRow.swift
//  VitesseRH
//
//  Created by Elo on 17/01/2025.
//

import SwiftUI

struct EditableRow: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            TextField("", text: $text)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(Color.white)
                )
                .frame(height: 40)
        }
    }
}

//#Preview {
//    EditableRow()
//}
