//
//  BreedDetailsView.swift
//  TheCatApp
//
//  Created by revangelista on 05/05/2024.
//

import SwiftUI

struct BreedDetailsView: View {
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image(ImageResource(name: "cat", bundle: .main))
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(height: 300, alignment: .top)
                    .clipShape(
                        .rect(topLeadingRadius: 20, topTrailingRadius: 20)
                    )
                FavoriteButton(isFavorite: false, favoriteStyle: .details)
                    .padding()
            }
            VStack(spacing: 16) {
                Text("Bokolaumius")
                    .font(.title)
                    .lineLimit(2)
                    .foregroundColor(.titleText)
                    .frame(maxWidth: .infinity, alignment: .center)
                TitleWithParagraphView(viewModel: .init(title: "Origin", description: "Egypt"))
                TitleWithParagraphView(viewModel:
                        .init(title: "Temperament",
                              description: "Active, Energetic, Independent, Intelligent, Gentle")
                )
                TitleWithParagraphView(viewModel:
                        .init(title: "Description",
                              description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.")
                )
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

#Preview {
    BreedDetailsView()
}
