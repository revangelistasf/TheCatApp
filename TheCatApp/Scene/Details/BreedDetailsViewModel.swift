//
//  BreedDetailsViewModel.swift
//  TheCatApp
//
//  Created by revangelista on 05/05/2024.
//

import Foundation

protocol BreedDetailsViewModelProtocol: ObservableObject {
    var title: String { get }
    var origin: String { get }
    var temperament: String { get }
    var description: String { get }
    var imageUrl: URL? { get }
    var isFavorite: Bool { get }
    func toggleFavorite()
}

final class BreedDetailsViewModel: BreedDetailsViewModelProtocol {
    @Published private var selectedBreed: Breed
    private var repository: BreedRepositoryProtocol

    var imageUrl: URL? {
        selectedBreed.imageUrl
    }

    var title: String {
        selectedBreed.name
    }

    var origin: String {
        selectedBreed.origin
    }

    var temperament: String {
        selectedBreed.temperament
    }

    var description: String {
        selectedBreed.description
    }

    var isFavorite: Bool {
        selectedBreed.isFavorite
    }

    init(selectedBreed: Breed, repository: BreedRepositoryProtocol = BreedRepository()) {
        self.selectedBreed = selectedBreed
        self.repository = repository
    }

    func toggleFavorite() {
        repository.toggleFavorite(breed: selectedBreed)
    }
}
