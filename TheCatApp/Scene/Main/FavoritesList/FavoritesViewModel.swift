//
//  FavoritesViewModel.swift
//  TheCatApp
//
//  Created by revangelista on 06/05/2024.
//

import Foundation
import SwiftData

protocol FavoritesViewModelProtocol: ObservableObject {
    var state: ViewState<[CardItem], Error> { get }
}

@Observable
final class FavoritesViewModel: FavoritesViewModelProtocol {
    private(set)var state: ViewState<[CardItem], Error>
    private var repository: BreedRepositoryProtocol

    init(repository: BreedRepositoryProtocol) {
        self.repository = repository
        self.state = .idle
        fetchFavoriteBreeds()
        configureObserver()
    }

    private func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchFavoriteBreeds), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }

    @objc private func fetchFavoriteBreeds() {
        self.state = .loading
        let cards = repository.fetchAllFavorites().map {
            CardItem(id: $0.id, title: $0.name, description: $0.lifeSpan, imageUrl: $0.imageUrl, isFavorite: $0.isFavorite)
        }
        state = .success(cards)
    }
}
