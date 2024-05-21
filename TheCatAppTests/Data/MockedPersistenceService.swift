//
//  MockedPersistenceService.swift
//  TheCatAppTests
//
//  Created by revangelista on 08/05/2024.
//

import CoreData
import Foundation
@testable import TheCatApp

class MockedPersistenceService: BreedPersistenceProtocol {
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

    func isFavorite(id: String) -> Bool {
        favorites.contains(where: { $0.id == id })
    }
}
