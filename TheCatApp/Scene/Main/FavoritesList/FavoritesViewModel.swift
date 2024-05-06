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

        Task {
            self.state = .loading
            await fetchFavoriteBreeds()
        }
    }

    @MainActor
    private func fetchFavoriteBreeds() async {

    }
}
