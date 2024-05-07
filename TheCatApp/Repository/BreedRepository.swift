//
//  BreedRepository.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

protocol BreedRepositoryProtocol {
    func fetchBreeds(page: Int) async throws -> [Breed]
    func toggleFavorite(breedId: String, isFavorite: Bool)
}

final class BreedRepository: BreedRepositoryProtocol {
    private let networkService: NetworkService
    private let persistenceService: BreedPersistenceProtocol

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init(networkService: NetworkService, persistenceService: BreedPersistenceProtocol = BreedPersistence()) {
        self.networkService = networkService
        self.persistenceService = persistenceService
    }

    func fetchBreeds(page: Int) async throws -> [Breed] {
        do {
            let responseData = try await networkService.request(BreedEndpoint.breeds(page: page))
            var breeds = try decoder.decode([Breed].self, from: responseData)
            let favoriteIds = try persistenceService.fetchFavorites()
            favoriteIds.forEach { idx in
                if let index = breeds.firstIndex(where: { $0.id == idx }) {
                    breeds[index].isFavorite = true
                }
            }
            
            return breeds
        } catch {
            #warning("remove this print after dealing with those errors properly")
            print(error)
            throw error
        }
    }

    func toggleFavorite(breedId: String, isFavorite: Bool) {
        isFavorite ? persistenceService.removeFavorite(idx: breedId) : persistenceService.addFavorite(idx: breedId)
    }
}
