//
//  CardItem.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import Foundation

struct CardItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    var description: String?
    var imageUrl: URL?
    var isFavorite: Bool = false
}
