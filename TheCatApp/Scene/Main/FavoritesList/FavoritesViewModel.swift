//
//  FavoritesViewModel.swift
//  TheCatApp
//
//  Created by revangelista on 06/05/2024.
//

import Foundation

protocol FavoritesViewModelProtocol: ObservableObject {
    var state: ViewState<[CardItem], Error> { get }
    func start()
    func toggleFavorite(item: CardItem)
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    @Published private(set)var state: ViewState<[CardItem], Error>
    private var repository: BreedRepositoryProtocol
    private var breeds: [Breed] = []

    init(repository: BreedRepositoryProtocol) {
        self.repository = repository
        self.state = .idle
    }

    func start() {
        fetchFavoriteBreeds()
    }

    private func fetchFavoriteBreeds() {
        self.state = .loading
        self.breeds = repository.fetchAllFavorites()
        let cards = self.breeds.map {
            CardItem(id: $0.id, title: $0.name, description: $0.lifeSpan, imageUrl: $0.imageUrl, isFavorite: $0.isFavorite)
        }
        state = .success(cards)
    }

    func toggleFavorite(item: CardItem) {
        guard let selectedBreed = breeds.first(where: { $0.id == item.id }) else { return }
        repository.toggleFavorite(breed: selectedBreed)
        fetchFavoriteBreeds()
    }
}
