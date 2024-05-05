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
    var referenceImageId: String?

    var imageUrl: URL? {
        URL(string: "https://cdn2.thecatapi.com/images/\(referenceImageId ?? "").jpg")
    }
}
