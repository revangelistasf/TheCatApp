//
//  CardItem.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import Foundation

struct CardItem: Identifiable, Equatable {
    let id: String
    let title: String
    var description: String?
    var imageUrl: URL?
    var isFavorite: Bool = false

    var averageLifeSpan: String? {
        let ages = description?.components(separatedBy: " - ").compactMap{ Int($0 )}
        guard let sum = ages?.reduce(0, +), let size = ages?.count else { return nil }
        let averageLifeSpan = Double(sum)/Double(size)
        return String(format: "%.1f", averageLifeSpan)
    }
}
