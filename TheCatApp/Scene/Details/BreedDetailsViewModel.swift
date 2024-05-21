//
//  BreedDetailsViewModel.swift
//  TheCatApp
//
//  Created by revangelista on 05/05/2024.
//

import Foundation
import Combine

protocol BreedDetailsViewModelProtocol: ObservableObject {
    var title: String { get }
    var origin: String { get }
    var temperament: String { get }
    var description: String { get }
    var imageUrl: URL? { get }
    var isFavorite: Bool { get set }
    func toggleFavorite()
}

final class BreedDetailsViewModel: BreedDetailsViewModelProtocol {
    @Published private var selectedBreed: Breed {
        didSet {
            print("new value setted")
        }
    }
    @Published var isFavorite: Bool
    private var repository: BreedRepositoryProtocol
    private var cancellable = Set<AnyCancellable>()

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

    init(selectedBreed: Breed, repository: BreedRepositoryProtocol = BreedRepository()) {
        self.selectedBreed = selectedBreed
        self.repository = repository
        self.isFavorite = selectedBreed.isFavorite
        setupObservers()
    }

    private func setupObservers() {
        selectedBreed.$isFavorite
            .dropFirst()
            .sink { [weak self] value in
                self?.isFavorite = value
            }
            .store(in: &cancellable)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshIsFavorite),
            name: .NSManagedObjectContextObjectsDidChange,
            object: nil
        )
    }

    @objc private func refreshIsFavorite() {
        selectedBreed.isFavorite = repository.isFavorite(id: selectedBreed.id)

    }

    func toggleFavorite() {
        repository.toggleFavorite(breed: selectedBreed)
    }
}
