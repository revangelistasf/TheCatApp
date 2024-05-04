//
//  BreedRepository.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

protocol BreedRepositoryProtocol {
    func fetchBreeds(page: Int) async throws -> [Breed]
}

final class BreedRepository: BreedRepositoryProtocol {
    private let networkService: NetworkService
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchBreeds(page: Int) async throws -> [Breed] {
        do {
            let responseData = try await networkService.request(BreedEndpoint.breeds(page: page))
            return try decoder.decode([Breed].self, from: responseData)
        } catch {
            #warning("remove this print after dealing with those errors properly")
            print(error)
            throw error
        }
    }
}
