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
    func start()
    func didDisplay(item: CardItem)
    func toggleFavorite(item: CardItem)
}

final class BreedListViewModel: BreedListViewModelProtocol {
    @Published private(set)var state: ViewState<[CardItem], Error>
    @Published var searchTerm: String = ""
    private var breeds: [Breed] = []

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
    }

    func start() {
        currentPage = 0
        state = .loading
        Task {
            await fetchBreeds()
        }
    }


    @MainActor
    func fetchBreeds(page: Int = 0) async {
        do {
            let result = try await repository.fetchBreeds(page: page)
            self.breeds.append(contentsOf: result)
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

    func toggleFavorite(item: CardItem) {
        guard let selectedBreed = breeds.first(where: { $0.id == item.id }) else { return }
        repository.toggleFavorite(breed: selectedBreed)
    }
}
