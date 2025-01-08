//
//  CreateCandidateView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct CreateCandidateView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    
    @ObservedObject var viewModel: CreateCandidateViewModel
    var token: String
    
    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Last Name", text: $lastName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Phone", text: $phone)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                let newCandidate = Candidate(
                    id: "",
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phone: phone,
                    note: nil,
                    linkedinURL: nil,
                    isFavorite: false
                )
                viewModel.addCandidate(candidate: newCandidate)
            }) {
                Text("Save")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .disabled(viewModel.errorMessage != nil)

            
            if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
            }
        }
        .padding()
    }
}
