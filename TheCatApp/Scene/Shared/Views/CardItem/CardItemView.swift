//
//  CardItemView.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import SwiftUI
import NukeUI

private enum Constants {
    static let imageHeight: CGFloat = 150
    static let imageAspectRatio: CGFloat = 150
    static let cardCornerRadius: CGFloat = 20
    static let cardBorderWidth: CGFloat = 1
    static let titleTextHeight: CGFloat = 50
    static let titleLineLimit: Int = 2
    static let buttonPadding: CGFloat = 8
    static let bottomSpacing: CGFloat = 8
}

struct CardItemView: View {
    @StateObject var cardItem: CardItem
    var action: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                LazyImage(url: cardItem.imageUrl) { state in
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
                .frame(height: Constants.imageHeight)

                Spacer()

                Text(cardItem.title)
                    .lineLimit(Constants.titleLineLimit)
                    .bold()
                    .padding(.horizontal)
                if cardItem.shouldShowLifeSpan, let lifeSpan = cardItem.averageLifeSpan {
                    Text("Life Span: \(lifeSpan) y/o")
                        .font(.subheadline)
                    .padding(.horizontal)
                }

                Spacer()
                    .frame(height: Constants.bottomSpacing)
            }

            FavoriteButton(isFavorite: $cardItem.isFavorite) {
                action?()
            }
            .padding(Constants.buttonPadding)
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .stroke(lineWidth: Constants.cardBorderWidth)
        )
    }
}
