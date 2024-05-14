//
//  Breed.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

class Breed: Codable, ObservableObject {
    let id: String
    let name: String
    let description: String
    let origin: String
    let temperament: String
    let referenceImageId: String?
    let lifeSpan: String
    @Published var isFavorite: Bool = false

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

// MARK: - Equatable
extension Breed: Equatable {
    static func == (lhs: Breed, rhs: Breed) -> Bool {
        lhs.id == rhs.id
    }
}
