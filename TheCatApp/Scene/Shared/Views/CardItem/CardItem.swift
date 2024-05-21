//
//  CardItem.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import Foundation
import Combine

final class CardItem: Identifiable, ObservableObject {
    @Published var isFavorite: Bool = false
    let id: String
    let title: String
    var description: String?
    var imageUrl: URL?
    var shouldShowLifeSpan: Bool
    private var cancellables = Set<AnyCancellable>()

    var averageLifeSpan: String? {
        let ages = description?.components(separatedBy: " - ").compactMap{ Int($0 )}
        guard let sum = ages?.reduce(0, +), let size = ages?.count else { return nil }
        let averageLifeSpan = Double(sum)/Double(size)
        return String(format: "%.1f", averageLifeSpan)
    }

    init(breed: Breed, shouldShowLifeSpan: Bool = false) {
        self.id = breed.id
        self.title = breed.name
        self.description = breed.lifeSpan
        self.imageUrl = breed.imageUrl
        self.isFavorite = breed.isFavorite
        self.shouldShowLifeSpan = shouldShowLifeSpan

        breed.$isFavorite
            .sink { [weak self] newValue in
                self?.isFavorite = newValue
            }
            .store(in: &cancellables)
    }
}

// MARK: - Equatable
extension CardItem: Equatable {
    static func == (lhs: CardItem, rhs: CardItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension CardItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
