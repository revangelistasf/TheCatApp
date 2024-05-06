//
//  BreedDetailsView.swift
//  TheCatApp
//
//  Created by revangelista on 05/05/2024.
//

import SwiftUI

struct BreedDetailsView<ViewModel: BreedDetailsViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: viewModel.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: Constants.imageHeight, alignment: .top)
                        .clipShape(.rect(cornerRadius: Constants.imageCornerRadius))
                } placeholder: {
                    Image(systemName: "cat.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: Constants.imageHeight, alignment: .top)
                        .padding()
                }

                FavoriteButton(isFavorite: false, favoriteStyle: .details)
                    .padding()
            }
            VStack(spacing: 16) {
                Text(viewModel.title)
                    .font(.title)
                    .lineLimit(2)
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
}

private enum Constants {
    static let imageHeight: CGFloat = 300
    static let imageCornerRadius: CGFloat = 20
}

#Preview {
    BreedDetailsView(viewModel: BreedDetailsViewModel(selectedBreed: .fixture()))
}
