//
//  BreedPersistence.swift
//  TheCatApp
//
//  Created by revangelista on 06/05/2024.
//

import CoreData

protocol BreedPersistenceProtocol {
    func fetchFavorites() throws -> [String]
    func addFavorite(idx: String)
    func removeFavorite(idx: String)
}

final class BreedPersistence: BreedPersistenceProtocol {
    private let container: NSPersistentContainer
    private lazy var favorites: Favorites? = Favorites(context: container.viewContext)

    init() {
        container = NSPersistentContainer(name: "TheCatApp")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func fetchFavorites() throws -> [String] {
        let request = NSFetchRequest<Favorites>(entityName: "Favorites")
        self.favorites = try container.viewContext.fetch(request).first
        return favorites?.idx.map { String($0) } ?? []
    }

    func addFavorite(idx: String) {
        if let favorites {
            favorites.idx.append(NSString(string: idx))
        } else {
            self.favorites = Favorites(context: container.viewContext)
            self.favorites?.idx.append(NSString(string: idx))
        }
        try? container.viewContext.save()
    }

    func removeFavorite(idx: String) {
        if let index = favorites?.idx.firstIndex(of: NSString(string: idx)) {
            favorites?.idx.remove(at: index)
            try? container.viewContext.save()
        }
    }
}
