//
//  BreedListViewModel.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import Foundation

protocol BreedListViewModelProtocol: ObservableObject {
    var state: ViewState<[CardItem], Error> { get }
    var searchTerm: String { get set }
    var isSearching: Bool { get }
    func didDisplay(item: CardItem)
    func addToFavorite(item: CardItem)
}

final class BreedListViewModel: BreedListViewModelProtocol {
    @Published private(set)var state: ViewState<[CardItem], Error>
    @Published var searchTerm: String = ""

    private var currentPage: Int = 0
    private var didReachLastPage = false

    private var paginationIndexThreshold: Int {
        Int(Double(state.value?.count ?? 0) * 0.8)
    }

    var isSearching: Bool {
        !searchTerm.isEmpty
    }

    let repository: BreedRepositoryProtocol

    init(repository: BreedRepositoryProtocol) {
        self.repository = repository
        self.state = .idle

        Task {
            state = .loading
            await fetchBreeds()
        }
    }

    @MainActor
    func fetchBreeds(page: Int = 0) async {
        do {
            let result = try await repository.fetchBreeds(page: page)
            var cardItems = state.value ?? []
            cardItems += result.map {
                CardItem(
                    id: $0.id,
                    title: $0.name,
                    imageUrl: $0.imageUrl,
                    isFavorite: $0.isFavorite
                )
            }
            if state.isLoadingNextPage, result.isEmpty {
                // API didn't inform the page number, or total items, so I did it to prevent new requests
                didReachLastPage = true
            }
            state = .success(cardItems)
            currentPage += 1
        } catch {
            // TODO: - Error Handling
        }
    }

    func didDisplay(item: CardItem) {
        guard !state.isLoadingNextPage,
              !didReachLastPage,
              !isSearching,
              let itemIndex = state.value?.firstIndex(of: item),
              itemIndex > paginationIndexThreshold
        else { return }

        Task {
            await MainActor.run {
                state = .loadingNextPage(state.value ?? [])
            }
            await fetchBreeds(page: currentPage)
        }

    }

    func addToFavorite(item: CardItem) {
        repository.toggleFavorite(breedId: item.id, isFavorite: item.isFavorite)
    }
}
