//
//  CardItemView.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import SwiftUI

private enum Constants {
    static let imageAspectRatio: CGFloat = 1
    static let cardCornerRadius: CGFloat = 20
    static let cardBorderWidth: CGFloat = 1
    static let titleTextHeight: CGFloat = 50
    static let titleLineLimit: Int = 2
}

struct CardItemView: View {
    let cardItem: CardItem
    var action: (() -> Void)?

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: cardItem.imageUrl) { image in
                    image.resizable()
                        .aspectRatio(1, contentMode: .fit)
                } placeholder: {
                    Image(systemName: "cat.circle.fill")
                        .resizable()
                        .aspectRatio(Constants.imageAspectRatio, contentMode: .fill)
                        .padding()
                }
                FavoriteButton(isFavorite: cardItem.isFavorite) {
                    action?()
                }
                .padding(8)
            }
            Text(cardItem.title)
                .lineLimit(Constants.titleLineLimit)
                .frame(height: Constants.titleTextHeight)
                .padding()
            if let description = cardItem.description {
                Text(description)
                .padding()
            }
            Spacer()
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .stroke(lineWidth: Constants.cardBorderWidth)
        )
    }
}
