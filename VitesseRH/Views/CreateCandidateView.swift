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
    @State private var linkedin = ""
    @State private var note = ""

    
    @ObservedObject var viewModel: CreateCandidateViewModel
    var token: String
    
    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .autocorrectionDisabled(true)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Last Name", text: $lastName)
                .autocorrectionDisabled(true)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Phone", text: $phone)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Linkedin", text: $linkedin)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Note", text: $note)
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
                HStack {
                    Spacer()
                    Text("Save")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
            }
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
            .padding()

            
            if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
            }
        }
        .padding()
    }
}
