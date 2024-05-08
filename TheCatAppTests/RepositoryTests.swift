//
//  TheCatAppTests.swift
//  TheCatAppTests
//
//  Created by revangelista on 08/05/2024.
//

import XCTest
@testable import TheCatApp
import CoreData

final class RepositoryTests: XCTestCase {
    private var mockedNetworkService: MockNetworkService!
    private var mockedPersistenceService: MockPersistenceService!
    private var sut: BreedRepositoryProtocol!

    override func setUp() {
        super.setUp()
        mockedNetworkService = MockNetworkService()
        mockedPersistenceService = MockPersistenceService()
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
        mockedNetworkService.onRequest = { _ in
            return mockedData.jsonData()!
        }

        runAsyncTest {
            let response = try await self.sut.fetchBreeds(page: 0)
            XCTAssertEqual(mockedData, response)
        }
    }

    func test_fetchBreeds_doesReturnCorrectFavoritedResult() throws {
        let mockedData = [Breed.fixture()]
        mockedNetworkService.onRequest = { _ in
            return mockedData.jsonData()!
        }
        try mockedPersistenceService.addFavorite(breed: Breed.fixture())

        runAsyncTest {
            let response = try await self.sut.fetchBreeds(page: 0)
            XCTAssertTrue(response.first?.isFavorite ?? false)
        }
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

extension Array where Element: Encodable {
    func jsonData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}

extension RepositoryTests {
    class MockNetworkService: NetworkServiceProtocol {
        var onRequest: ((_ endpoint: Endpoint) async throws -> Data)?
        func request(_ endpoint: Endpoint) async throws -> Data {
            guard let request = try await onRequest?(endpoint) else { throw NetworkError.invalidResponse }
            return request
        }
    }

    class MockPersistenceService: BreedPersistenceProtocol {
        var favorites: [BreedPersistenceModel] = []
        var successRequest: Bool = true

        func fetchFavorites() throws -> [BreedPersistenceModel] {
            if successRequest {
                favorites
            } else {
                throw PersistenceError.failedToFetch
            }
        }
        
        func addFavorite(breed: Breed) throws {
            let persistenceModel = BreedPersistenceModel(breed: breed, context: persistentContainer.viewContext)
            favorites.append(persistenceModel)
        }
        
        func removeFavorite(index: String) throws {
            favorites.removeAll(where: { $0.id == index} )
        }

        lazy var persistentContainer: NSPersistentContainer = {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            let container = NSPersistentContainer(name: "TheCatApp")
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
    }
}
