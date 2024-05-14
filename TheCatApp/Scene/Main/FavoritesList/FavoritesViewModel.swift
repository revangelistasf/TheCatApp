//
//  FavoritesViewModel.swift
//  TheCatApp
//
//  Created by revangelista on 06/05/2024.
//

import Foundation

protocol FavoritesViewModelProtocol: ObservableObject {
    var state: ViewState<[CardItem], ErrorViewType> { get }
    func start()
    func toggleFavorite(item: CardItem)
    func getBreedModel(item: CardItem) -> Breed?
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    @Published private(set)var state: ViewState<[CardItem], ErrorViewType>
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
        do {
            self.state = .loading
            self.breeds = try repository.fetchAllFavorites()
            let cards = self.breeds.map {
                CardItem(breed: $0)
            }
            
            state = .success(cards)
        } catch {
            // In that case I'll let this as is, because I've mapped only this error
            state = .error(.failedToFetchPersistenceData)
        }
    }

    func toggleFavorite(item: CardItem) {
        guard let selectedBreed = breeds.first(where: { $0.id == item.id }) else { return }
        repository.toggleFavorite(breed: selectedBreed)
        fetchFavoriteBreeds()
    }

    func getBreedModel(item: CardItem) -> Breed? {
        return breeds.first(where: { $0.id == item.id })
    }
}
