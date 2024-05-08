//
//  CardItemView.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import SwiftUI

private enum Constants {
    static let imageHeight: CGFloat = 150
    static let imageAspectRatio: CGFloat = 150
    static let cardCornerRadius: CGFloat = 20
    static let cardBorderWidth: CGFloat = 1
    static let titleTextHeight: CGFloat = 50
    static let titleLineLimit: Int = 2
    static let buttonPadding: CGFloat = 8
}

struct CardItemView: View {
    let cardItem: CardItem
    var action: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                AsyncImage(url: cardItem.imageUrl) { image in
                    image.resizable()
                        .clipped()
                } placeholder: {
                    Image(systemName: "cat.circle.fill")
                        .resizable()
                        .padding()
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.imageHeight)
                Spacer()
                Text(cardItem.title)
                    .lineLimit(Constants.titleLineLimit)
                    .bold()
                    .padding()
                if let description = cardItem.description {
                    Text(description)
                    .padding()
                }
            }
            FavoriteButton(isFavorite: cardItem.isFavorite) {
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
