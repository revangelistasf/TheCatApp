//
//  Breed.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

class Breed: Decodable {
    let id: String
    let name: String
    let description: String
    let origin: String
    let temperament: String
    let referenceImageId: String?
    let lifeSpan: String
    var isFavorite: Bool = false

    var imageUrl: URL? {
        URL(string: "https://cdn2.thecatapi.com/images/\(referenceImageId ?? "").jpg")
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case origin
        case temperament
        case referenceImageId
        case lifeSpan
    }

    init(id: String, name: String, description: String, origin: String, temperament: String, referenceImageId: String?, lifeSpan: String, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.origin = origin
        self.temperament = temperament
        self.referenceImageId = referenceImageId
        self.lifeSpan = lifeSpan
        self.isFavorite = isFavorite
    }

    init(persistenceModel: BreedPersistenceModel) {
        self.id = persistenceModel.id
        self.name = persistenceModel.name
        self.description = persistenceModel.breedDescription
        self.origin = persistenceModel.origin
        self.temperament = persistenceModel.temperament
        self.referenceImageId = persistenceModel.referenceImageId
        self.lifeSpan = persistenceModel.lifeSpan
        self.isFavorite = persistenceModel.isFavorite
    }
}

extension Breed {
    static func fixture(
        id: String = "abys",
        name: String = "Abyssinian",
        description: String = "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
        origin: String = "Egypt",
        temperament: String = "Active, Energetic, Independent, Intelligent, Gentle",
        referenceImageId: String? = "0XYvRd7oD",
        lifeSpan: String = "14 - 15",
        isFavorite: Bool = false
    ) -> Breed {
        return Breed(
            id: id,
            name: name,
            description: description,
            origin: origin,
            temperament: temperament,
            referenceImageId: referenceImageId,
            lifeSpan: lifeSpan,
            isFavorite: isFavorite
        )
    }
}
