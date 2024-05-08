//
//  Breed+Fixture.swift
//  TheCatAppTests
//
//  Created by revangelista on 08/05/2024.
//

import Foundation
@testable import TheCatApp

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
