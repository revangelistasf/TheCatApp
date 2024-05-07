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
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: Constants.padding) {
                    ForEach(itemsToDisplay, id: \.uuid) { item in
                        CardItemView(cardItem: item) {
                            viewModel.toggleFavorite(item: item)
                        }
                    }
                }
                .padding()
            }
            .stateView(shouldShowState: itemsToDisplay.isEmpty) {
                emptyStateView
            }
        }
        .onAppear {
            viewModel.start()
        }
    }

    var emptyStateView: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(.sadCat)
                .resizable()
                .frame(width: Constants.emptyStateImageSize, height: Constants.emptyStateImageSize)
            Text("No favorites added yet.")
                .font(.title)
                .multilineTextAlignment(.center)
                .foregroundStyle(.titleText)
            Spacer()
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
