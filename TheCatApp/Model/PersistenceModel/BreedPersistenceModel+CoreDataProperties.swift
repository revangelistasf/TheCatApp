//
//  BreedPersistenceModel+CoreDataProperties.swift
//  TheCatApp
//
//  Created by revangelista on 07/05/2024.
//
//

import Foundation
import CoreData


extension BreedPersistenceModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreedPersistenceModel> {
        return NSFetchRequest<BreedPersistenceModel>(entityName: "BreedPersistenceModel")
    }

    @NSManaged public var breedDescription: String
    @NSManaged public var id: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var lifeSpan: String
    @NSManaged public var name: String
    @NSManaged public var origin: String
    @NSManaged public var referenceImageId: String?
    @NSManaged public var temperament: String

    convenience init(breed: Breed, context: NSManagedObjectContext) {
        self.init(context: context)
        self.breedDescription = breed.description
        self.id = breed.id
        self.isFavorite = breed.isFavorite
        self.lifeSpan = breed.lifeSpan
        self.name = breed.name
        self.origin = breed.origin
        self.referenceImageId = breed.referenceImageId
        self.temperament = breed.temperament
    }

}

extension BreedPersistenceModel : Identifiable {

}
