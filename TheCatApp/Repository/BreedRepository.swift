//
//  BreedRepository.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

final class BreedRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchBreeds() async throws -> [Breed] {
        do {
            let responseData = try await networkService.request(BreedEndpoint.breeds)
            return try JSONDecoder().decode([Breed].self, from: responseData)
        } catch {
            #warning("remove this print after dealing with those errors properly")
            print(error)
            throw error
        }
    }
}
