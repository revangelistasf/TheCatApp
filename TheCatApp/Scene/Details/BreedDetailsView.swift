//
//  BreedDetailsView.swift
//  TheCatApp
//
//  Created by revangelista on 05/05/2024.
//

import SwiftUI
import NukeUI

struct BreedDetailsView<ViewModel: BreedDetailsViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .topTrailing) {
                    LazyImage(url: viewModel.imageUrl) { state in
                        if let image = state.image {
                            image.resizable()
                                .clipped()
                        } else {
                            Image(systemName: "cat.circle.fill")
                                .resizable()
                                .padding()
                        }
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.imageHeight, alignment: .top)

                    FavoriteButton(isFavorite: $viewModel.isFavorite, favoriteStyle: .details) {
                        viewModel.toggleFavorite()
                    }
                    .padding()
                }

                VStack(spacing: Constants.textSpacing) {
                    Text(viewModel.title)
                        .font(.title)
                        .lineLimit(Constants.titleLineLimit)
                        .foregroundColor(.titleText)
                        .frame(maxWidth: .infinity, alignment: .center)
                    TitleWithParagraphView(viewModel: .init(title: "Origin", description: viewModel.origin))
                    TitleWithParagraphView(viewModel: .init(title: "Temperament",description: viewModel.temperament))
                    TitleWithParagraphView(viewModel: .init(title: "Description", description: viewModel.description))
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - View Constants
private enum Constants {
    static let imageHeight: CGFloat = 300
    static let imageCornerRadius: CGFloat = 20
    static let textSpacing: CGFloat = 16
    static let titleLineLimit: Int = 2
}
