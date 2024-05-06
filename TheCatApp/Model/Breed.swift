//
//  Breed.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

struct Breed: Decodable {
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
}

extension Breed {
    static func fixture(
        id: String = "abys",
        name: String = "Abyssinian",
        description: String = "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
        origin: String = "Egypt",
        temperament: String = "Active, Energetic, Independent, Intelligent, Gentle",
        referenceImageId: String? = "0XYvRd7oD",
        lifeSpan: String = "14 - 15"
    ) -> Breed {
        return Breed(
            id: id,
            name: name,
            description: description,
            origin: origin,
            temperament: temperament,
            referenceImageId: referenceImageId,
            lifeSpan: lifeSpan
        )
    }
}
