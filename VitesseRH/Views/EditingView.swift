//
//  EditingView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct EditingView: View {
    @Binding var candidate: Candidate
    @ObservedObject var viewModel: EditingViewModel

    var body: some View {
        VStack {
            TextField("First Name", text: $candidate.firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Last Name", text: $candidate.lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $candidate.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Phone", text: $candidate.phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("LinkedIn", text: Binding(
                get: { candidate.linkedinURL ?? "" },
                set: { candidate.linkedinURL = $0 }
            ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Note", text: Binding(
                get: { candidate.note ?? "" },
                set: { candidate.note = $0 }
            ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save Changes") {
                viewModel.saveChanges()  
            }
            .padding()
        }
        .navigationTitle("Edit Candidate")
        .padding()
    }
}
