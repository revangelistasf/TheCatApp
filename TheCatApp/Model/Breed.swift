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
    let referenceImageId: String
}
