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
        case .success(let value):
            return value
        default:
            return []
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: Constants.padding) {
                    ForEach(itemsToDisplay, id: \.id) { item in
                        NavigationLink(value: item) {
                            CardItemView(cardItem: item) {
                                viewModel.toggleFavorite(item: item)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationDestination(for: CardItem.self) { cardItem in
                if let selectedBreed = viewModel.getBreedModel(item: cardItem) {
                    BreedDetailsView(viewModel: BreedDetailsViewModel(selectedBreed: selectedBreed))
                }
            }
            .stateView(shouldShowState: itemsToDisplay.isEmpty) {
                ErrorViewFactory.getErrorView(type: .emptyFavorites)
            }
            .onAppear {
                viewModel.start()
            }
        }
        .stateView(shouldShowState: viewModel.state.isError) {
            ErrorViewFactory.getErrorView(type: viewModel.state.error ?? .generic, action: viewModel.start)
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
    static let emptyStateImageSize: CGFloat = 100
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel(repository: BreedRepository()))
}
