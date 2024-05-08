//
//  FavoriteListView.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import SwiftUI

struct FavoritesView<ViewModel: FavoritesViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    @State var selectedCard: CardItem? = nil
    @State var showingSheet = false

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
                    ForEach(itemsToDisplay, id: \.uuid) { item in
                        CardItemView(cardItem: item) {
                            viewModel.toggleFavorite(item: item)
                        }
                        .onTapGesture {
                            self.selectedCard = item
                            self.showingSheet = true
                        }
                    }
                }
                .padding()
            }
            .stateView(shouldShowState: itemsToDisplay.isEmpty) {
                ErrorViewFactory.getErrorView(type: .emptyFavorites)
            }
        }
        .onAppear {
            viewModel.start()
        }
        .stateView(shouldShowState: viewModel.state.isError) {
            ErrorViewFactory.getErrorView(type: viewModel.state.error ?? .generic, action: viewModel.start)
        }
        .sheet(isPresented: $showingSheet, onDismiss: {
            selectedCard = nil
        }, content: {
            if let selectedCard = selectedCard, let model = viewModel.getBreedModel(item: selectedCard) {
                BreedDetailsView(viewModel: BreedDetailsViewModel(selectedBreed: model))
            }
        })
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
