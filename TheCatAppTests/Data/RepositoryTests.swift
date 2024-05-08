//
//  TheCatAppTests.swift
//  TheCatAppTests
//
//  Created by revangelista on 08/05/2024.
//

import XCTest
@testable import TheCatApp

final class RepositoryTests: XCTestCase {
    private var mockedNetworkService: MockedNetworkService!
    private var mockedPersistenceService: MockedPersistenceService!
    private var sut: BreedRepository!

    override func setUp() {
        super.setUp()
        mockedNetworkService = MockedNetworkService()
        mockedPersistenceService = MockedPersistenceService()
        sut = BreedRepository(networkService: mockedNetworkService, persistenceService: mockedPersistenceService)
    }

    override func tearDown() {
        super.tearDown()
        mockedNetworkService = nil
        mockedPersistenceService = nil
        sut = nil
    }

    func test_fetchAllFavorites_persistenceReturnSuccess_doesReturnFavorites() {
        try! mockedPersistenceService.addFavorite(breed: .fixture())
        mockedPersistenceService.successRequest = true
        let favorites = try! sut.fetchAllFavorites()
        XCTAssertEqual(favorites, [.fixture()])
    }

    func test_fetchAllFavorites_persistenceThrowsError_doesThrowsPersistenceError() {
        try! mockedPersistenceService.addFavorite(breed: .fixture())
        mockedPersistenceService.successRequest = false
        XCTAssertThrowsError(try sut.fetchAllFavorites()) { error in
            XCTAssertEqual(error as! PersistenceError, .failedToFetch)
        }
    }

    func test_fetchBreeds_doesReturnCorrectResult() {
        let mockedData = [Breed.fixture()]

        let expectation = expectation(description: "waiting")
        Task {
            mockedNetworkService.onRequest = { _ in
                return mockedData.jsonData()!
            }

            let response = try await self.sut.fetchBreeds(page: 0)
            XCTAssertEqual(mockedData, response)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_fetchBreeds_doesReturnCorrectFavoritedResult() throws {
        let mockedData = [Breed.fixture()]
        mockedNetworkService.onRequest = { _ in
            return mockedData.jsonData()!
        }
        try mockedPersistenceService.addFavorite(breed: Breed.fixture())

        let expectation = expectation(description: "waiting")
        Task {
            let response = try await self.sut.fetchBreeds(page: 0)
            XCTAssertTrue(response.first?.isFavorite ?? false)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_toggleFavorite_souldChangePropertyAndAddToDatabase() {
        let mockedData = Breed.fixture()
        sut.toggleFavorite(breed: mockedData)
        XCTAssertEqual(mockedData.isFavorite, true)
        XCTAssertEqual(mockedPersistenceService.favorites.count, 1)
        sut.toggleFavorite(breed: mockedData)
        XCTAssertEqual(mockedPersistenceService.favorites.count, 0)
    }
}
