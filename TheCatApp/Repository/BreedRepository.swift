//
//  BreedRepository.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

protocol BreedRepositoryProtocol {
    func fetchBreeds(page: Int) async throws -> [Breed]
    func toggleFavorite(breed: Breed)
    func fetchAllFavorites() throws -> [Breed]
}

final class BreedRepository: BreedRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let persistenceService: BreedPersistenceProtocol

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        persistenceService: BreedPersistenceProtocol = BreedPersistence()
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
    }

    func fetchBreeds(page: Int) async throws -> [Breed] {
        let responseData = try await networkService.request(BreedEndpoint.breeds(page: page))
        let breeds = try decoder.decode([Breed].self, from: responseData)
        let favorites = try persistenceService.fetchFavorites()
        favorites.forEach { favorite in
            if let index = breeds.firstIndex(where: { $0.id == favorite.id }) {
                breeds[index].isFavorite = true
            }
        }
        return breeds
    }

    func fetchAllFavorites() throws -> [Breed] {
        do {
            let repoResult = try persistenceService.fetchFavorites()
            return repoResult.map { Breed(persistenceModel: $0) }
        } catch {
            throw PersistenceError.failedToFetch
        }
    }

    func toggleFavorite(breed: Breed) {
        do {
            if breed.isFavorite {
                breed.isFavorite = false
                try persistenceService.removeFavorite(index: breed.id)
            } else {
                breed.isFavorite = true
                try persistenceService.addFavorite(breed: breed)
            }
        } catch {
            // This error won't show anything to the user
            print(error.localizedDescription)
        }

    }
}
