//
//  FavoriteListView.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import SwiftUI

struct FavoritesView<ViewModel: FavoritesViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel

    private let gridItemLayout = Array(
        repeating: GridItem(.flexible(), spacing: Constants.padding, alignment: .top),
        count: Constants.numberOfColumns
    )

    private var itemsToDisplay: [CardItem] {
        switch viewModel.state {
        case .success(let value), .loadingNextPage(let value):
            return value
        default:
            return []
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: Constants.padding) {
                    ForEach(itemsToDisplay, id: \.uuid) { item in
                        CardItemView(cardItem: item)
                    }
                }
                .padding()
            }
        }
    }

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

// MARK: - View Constants
private enum Constants {
    static let padding: CGFloat = 16
    static let numberOfColumns: Int = 2
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel(repository: BreedRepository(networkService: NetworkService())))
}
