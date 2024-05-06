//
//  BreedDetailsViewModel.swift
//  TheCatApp
//
//  Created by revangelista on 05/05/2024.
//

import Foundation

protocol BreedDetailsViewModelProtocol: ObservableObject {
    var title: String { get }
    var origin: String { get }
    var temperament: String { get }
    var description: String { get }
    var imageUrl: URL? { get }
}

final class BreedDetailsViewModel: BreedDetailsViewModelProtocol {
    private var selectedBreed: Breed

    var imageUrl: URL? {
        selectedBreed.imageUrl
    }

    var title: String {
        selectedBreed.name
    }

    var origin: String {
        selectedBreed.origin
    }

    var temperament: String {
        selectedBreed.temperament
    }

    var description: String {
        selectedBreed.description
    }

    init(selectedBreed: Breed) {
        self.selectedBreed = selectedBreed
    }
}
