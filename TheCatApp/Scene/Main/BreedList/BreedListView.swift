//
//  BreedListView.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import SwiftUI

struct BreedListView<ViewModel: BreedListViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    @Environment(\.dismissSearch) private var dismissSearch

    private let gridItemLayout = Array(
        repeating: GridItem(.flexible(), spacing: Constants.padding, alignment: .top),
        count: Constants.numberOfColumns
    )

    private var itemsToDisplay: [CardItem] {
        switch viewModel.state {
        case .success(let value), .loadingNextPage(let value):
            if viewModel.isSearching {
                return value.filter { $0.title.lowercased().contains(viewModel.searchTerm.lowercased()) }
            } else {
                return value
            }
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
                            .onAppear {
                                viewModel.didDisplay(item: item)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                if viewModel.state.isLoadingNextPage, !viewModel.isSearching {
                    ProgressView()
                }
            }
            .navigationDestination(for: CardItem.self) { cardItem in
                if let selectedBreed = viewModel.getBreedModel(item: cardItem) {
                    BreedDetailsView(viewModel: BreedDetailsViewModel(selectedBreed: selectedBreed))
                }
            }
            .stateView(shouldShowState: viewModel.state.isLoading) {
                ProgressView()
            }
            .onAppear {
                viewModel.start()
            }
            .stateView(shouldShowState: viewModel.state.isSuccess && itemsToDisplay.isEmpty) {
                ErrorViewFactory.getErrorView(type: .noResults)
            }
            .searchable(text: $viewModel.searchTerm)
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
}
