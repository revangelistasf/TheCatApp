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
    private var mockNetworkService: MockNetworkService!
    private var mockPersistenceService: MockPersistenceService!
    private var sut: BreedRepositoryProtocol!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockPersistenceService = MockPersistenceService()
        sut = BreedRepository(networkService: mockNetworkService, persistenceService: mockPersistenceService)
    }

    override func tearDown() {
        super.tearDown()
        mockNetworkService = nil
        mockPersistenceService = nil
        sut = nil
    }

    func test_fetchAllFavorites_persistenceReturnSuccess_doesReturnFavorites() {
        try! mockPersistenceService.addFavorite(breed: .fixture())
        mockPersistenceService.successRequest = true
        let favorites = try! sut.fetchAllFavorites()
        XCTAssertEqual(favorites, [.fixture()])
    }

    func test_fetchAllFavorites_persistenceThrowsError_doesThrowsPersistenceError() {
        try! mockPersistenceService.addFavorite(breed: .fixture())
        mockPersistenceService.successRequest = false
        XCTAssertThrowsError(try sut.fetchAllFavorites()) { error in
            XCTAssertEqual(error as! PersistenceError, .failedToFetch)
        }
    }
}

extension RepositoryTests {
    class MockNetworkService: NetworkServiceProtocol {
        func request(_ endpoint: Endpoint) async throws -> Data {
            return Data()
        }
    }

    class MockPersistenceService: BreedPersistenceProtocol {
        var favorites: [BreedPersistenceModel] = []
        var successRequest: Bool = false

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
            favorites.remove(at: Int(index)!)
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
