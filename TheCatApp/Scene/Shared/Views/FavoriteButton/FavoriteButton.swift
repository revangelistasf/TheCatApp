//
//  FavoriteButton.swift
//  TheCatApp
//
//  Created by revangelista on 05/05/2024.
//

import SwiftUI

enum FavoriteType {
    case small
    case large
}

struct FavoriteButton: View {
    @State var isFavorite: Bool
    var favoriteType: FavoriteType = .small
    var size: CGFloat {
        switch favoriteType {
        case .small:
            return Constants.smallSize
        case .large:
            return Constants.largeSize
        }
    }

    var body: some View {
        Button {
            isFavorite.toggle()
        } label: {
            Label("add favorites", systemImage: Constants.imageName)
                .labelStyle(.iconOnly)
                .foregroundStyle(isFavorite ? .red : .black)
                .font(.system(size: size / 2))
        }
        .frame(width: size, height: size)
        .background(.white)
        .clipShape(Circle())
    }
}

private enum Constants {
    static let imageName: String = "heart.fill"
    static let smallSize: CGFloat = 24
    static let largeSize: CGFloat = 48
}

#Preview {
    VStack {
        FavoriteButton(isFavorite: true)
        FavoriteButton(isFavorite: false)
    }
    .background(.black)
}
