//
//  BreedListViewModelTests.swift
//  TheCatAppTests
//
//  Created by revangelista on 08/05/2024.
//

import XCTest
@testable import TheCatApp

final class BreedListViewModelTests: XCTestCase {
    private var mockedBreedRepository: MockedBreedRepository!
    private var sut: BreedListViewModel!

    override func setUp() {
        super.setUp()
        mockedBreedRepository = MockedBreedRepository()
        sut = BreedListViewModel(repository: mockedBreedRepository)
    }

    override func tearDown() {
        super.tearDown()
        mockedBreedRepository = nil
        sut = nil
    }

    func test_start_doesTheViewStateIsLoading() {
        let expectation = expectation(description: "waiting")
        Task {
            await self.sut.fetchBreeds(page: 0)
            XCTAssertFalse(self.sut.state.isSuccess)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchBreeds_doesCreateCardsWithCorrectValue() {
        let mockedBreed = Breed.fixture(id: "cardItemId", name: "cardItemName")
        let mockedCardItem = CardItem(id: mockedBreed.id, title: mockedBreed.name)

        let expectation = expectation(description: "waiting")
        Task {
            self.mockedBreedRepository.onFetchBreeds = { _ in
                return [mockedBreed]
            }

            await self.sut.fetchBreeds(page: 0)
            XCTAssertEqual(self.sut.state.value?.first?.id, mockedCardItem.id)
            expectation.fulfill()
        } 

        wait(for: [expectation], timeout: 1)
    }

    func test_fetchBreeds_withGenericNetworkError_doesStateGeneric() {
        let expectation = expectation(description: "waiting")
        mockedBreedRepository.onFetchBreeds = { _ in
            throw NetworkError.generic
        }

        Task {
            await self.sut.fetchBreeds(page: 0)
            XCTAssertEqual(self.sut.state.error, .generic)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchBreeds_withInvalidResponseNetworkError_doesStateGeneric() {
        let expectation = expectation(description: "waiting")
        mockedBreedRepository.onFetchBreeds = { _ in
            throw NetworkError.invalidResponse
        }

        Task {
            await self.sut.fetchBreeds(page: 0)
            XCTAssertEqual(self.sut.state.error, .generic)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchBreeds_withServerError_doesStateServerError() {
        let expectation = expectation(description: "waiting")
        mockedBreedRepository.onFetchBreeds = { _ in
            throw NetworkError.serverError(0)
        }

        Task {
            await self.sut.fetchBreeds(page: 0)
            XCTAssertEqual(self.sut.state.error, .serverError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchBreeds_withClientError_doesStateClientError() {
        let expectation = expectation(description: "waiting")
        mockedBreedRepository.onFetchBreeds = { _ in
            throw NetworkError.clientError(0)
        }

        Task {
            await self.sut.fetchBreeds(page: 0)
            XCTAssertEqual(self.sut.state.error, .clientError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}

extension BreedListViewModelTests {
    class MockedBreedRepository: BreedRepositoryProtocol {
        var onFetchBreeds: ((_ page: Int) async throws -> [Breed])?
        func fetchBreeds(page: Int) async throws -> [Breed] {
            guard let request = try await onFetchBreeds?(page) else { throw ErrorViewType.generic }
            return request
        }

        func toggleFavorite(breed: Breed) { }

        func fetchAllFavorites() throws -> [Breed] { return [] }

    }
}
