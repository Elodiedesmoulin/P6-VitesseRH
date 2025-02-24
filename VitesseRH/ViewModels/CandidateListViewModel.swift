//
//  CandidateListViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

enum EditingMode {
    case inactive, active
}

final class CandidateListViewModel: ObservableObject {
    private let onSignOut: () -> Void
    private let service: VitesseRHServiceProtocol
    
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
    
    init(onSignOut: @escaping () -> Void,
         service: VitesseRHServiceProtocol = VitesseRHService(),
         autoFetch: Bool = true) {
        self.onSignOut = onSignOut
        self.service = service
        if autoFetch { getCandidates() }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getCandidates),
                                               name: .needUpdate,
                                               object: nil)
    }
    
    @objc func getCandidates() {
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
    
    func toggleEditMode() {
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
        let searchQuery = filter.search.lowercased()
        candidates = allCandidates.filter { candidate in
            let matchesFavorites = filter.favorites ? candidate.isFavorite : true
            let matchesSearch = searchQuery.isEmpty ||
                candidate.firstName.lowercased().contains(searchQuery) ||
                candidate.lastName.lowercased().contains(searchQuery)
            return matchesFavorites && matchesSearch
        }
    }
}
