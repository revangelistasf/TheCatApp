//
//  CardItem.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import Foundation
import Combine

class CardItem: Identifiable, Equatable, ObservableObject {
    let id: String
    let title: String
    var description: String?
    var imageUrl: URL?
    @Published var isFavorite: Bool = false

    private var cancellables = Set<AnyCancellable>()

    var averageLifeSpan: String? {
        let ages = description?.components(separatedBy: " - ").compactMap{ Int($0 )}
        guard let sum = ages?.reduce(0, +), let size = ages?.count else { return nil }
        let averageLifeSpan = Double(sum)/Double(size)
        return String(format: "%.1f", averageLifeSpan)
    }

    init(breed: Breed) {
        self.id = breed.id
        self.title = breed.name
        self.imageUrl = breed.imageUrl
        self.isFavorite = breed.isFavorite

        breed.$isFavorite
            .sink { [weak self] newValue in
                self?.isFavorite = newValue
            }
            .store(in: &cancellables)
    }

    static func == (lhs: CardItem, rhs: CardItem) -> Bool {
        lhs.id == rhs.id
    }

}
