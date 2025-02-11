//
//  CandidateListViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation
import Combine

enum EditingMode {
    case inactive, active
}

final class CandidateListViewModel: ObservableObject {
    private let onSignOut: () -> Void
    private let service = VitesseRHService()
    
    @Published private(set) var allCandidates: [Candidate] = [] {
        didSet { applyFilter() }
    }
    @Published var candidates: [Candidate] = []
    @Published var filter: (search: String, favorites: Bool) = ("", false) {
        didSet { applyFilter() }
    }
    @Published var selection: Set<String> = []
    @Published var editMode: EditingMode = .inactive
    @Published private(set) var errorMessage = ""
    @Published private(set) var inProgress = false
    
    var isAdmin: Bool { AuthenticationManager.shared.isAdmin() }
    var inEditMode: Bool { editMode == .active }
    
    init(onSignOut: @escaping () -> Void) {
        self.onSignOut = onSignOut
        getCandidates()
        NotificationCenter.default.addObserver(self, selector: #selector(needUpdate), name: .needUpdate, object: nil)
    }
    
    func getCandidates() {
        guard !inProgress else { return }
        inProgress = true
        Task {
            let result = await service.getCandidates()
            await MainActor.run {
                switch result {
                case .success(let candidates):
                    self.allCandidates = candidates
                    self.errorMessage = ""
                case .failure(let error):
                    self.errorMessage = "\(error.title) \(error.localizedDescription)"
                }
                self.inProgress = false
            }
        }
    }
    
    func editModeToggle() {
        editMode = (editMode == .active) ? .inactive : .active
        if editMode == .inactive { selection.removeAll() }
    }
    
    func deleteSelection() {
        guard !selection.isEmpty else { return }
        inProgress = true
        Task {
            for candidateId in selection {
                _ = await service.deleteCandidate(withId: candidateId)
            }
            await MainActor.run {
                self.allCandidates.removeAll { self.selection.contains($0.id) }
                self.selection.removeAll()
                self.editMode = .inactive
                self.inProgress = false
            }
        }
    }
    
    func signOut() {
        onSignOut()
    }
    
    func createCandidate(firstName: String, lastName: String, email: String, phone: String, linkedinURL: String, note: String) {
        inProgress = true
        let newCandidate = Candidate(
            id: UUID().uuidString,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            note: note,
            linkedinURL: linkedinURL,
            isFavorite: false
        )
        Task {
            let result = await service.addCandidate(candidate: newCandidate)
            await MainActor.run {
                switch result {
                case .success(let candidate):
                    self.allCandidates.append(candidate)
                case .failure(let error):
                    self.errorMessage = "\(error.title) \(error.localizedDescription)"
                }
                self.inProgress = false
            }
        }
    }
    
    private func applyFilter() {
        let searchLowercased = filter.search.lowercased()
        candidates = allCandidates.filter {
            let matchesFavorites = filter.favorites ? $0.isFavorite : true
            let matchesSearch = searchLowercased.isEmpty ||
                $0.firstName.lowercased().contains(searchLowercased) ||
                $0.lastName.lowercased().contains(searchLowercased)
            return matchesFavorites && matchesSearch
        }
    }
    
    @objc private func needUpdate() {
        getCandidates()
    }
}
