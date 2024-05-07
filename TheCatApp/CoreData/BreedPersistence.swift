//
//  BreedPersistence.swift
//  TheCatApp
//
//  Created by revangelista on 06/05/2024.
//

import CoreData

protocol BreedPersistenceProtocol {
    func fetchFavorites() throws -> [BreedPersistenceModel]
    func addFavorite(breed: Breed) throws
    func removeFavorite(index: String) throws
}

final class BreedPersistence: BreedPersistenceProtocol {
    private static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TheCatApp")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        return Self.container.viewContext
    }
    private var favorites: [BreedPersistenceModel] = []

    func fetchFavorites() throws -> [BreedPersistenceModel] {
        let request = NSFetchRequest<BreedPersistenceModel>(entityName: "BreedPersistenceModel")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return try context.fetch(request)
    }

    func addFavorite(breed: Breed) throws {
        self.favorites = try fetchFavorites()
        self.favorites.append(BreedPersistenceModel(breed: breed, context: context))
        try? context.save()
    }

    func removeFavorite(index: String) throws {
        self.favorites = try fetchFavorites()
        if let favoriteIndex = self.favorites.compactMap({$0.id}).firstIndex(of: index) {
            context.delete(self.favorites[favoriteIndex])
            try? context.save()
        }
    }
}
