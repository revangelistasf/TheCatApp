//
//  BreedListView.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import SwiftUI

struct BreedListView<ViewModel: BreedListViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel

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

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: Constants.padding) {
                    ForEach(itemsToDisplay, id: \.id) { item in
                        CardItemView(cardItem: item)
                            .onAppear {
                                viewModel.didDisplay(item: item)
                            }
                    }
                }
                .padding()

                if viewModel.state.isLoadingNextPage, !viewModel.isSearching {
                    ProgressView()
                }
            }
        }
        .searchable(text: $viewModel.searchTerm)
    }
}

// MARK: - View Constants
private enum Constants {
    static let padding: CGFloat = 16
    static let numberOfColumns: Int = 2
}