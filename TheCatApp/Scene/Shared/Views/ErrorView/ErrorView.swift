//
//  ErrorView.swift
//  TheCatApp
//
//  Created by revangelista on 08/05/2024.
//

import SwiftUI

struct ErrorView: View {
    private var model: ErrorModel

    var body: some View {
        VStack(alignment: .center, spacing: Constants.innerSpacing) {
            Spacer()
            Image(model.image)
                .resizable()
                .frame(width: Constants.imageSize, height: Constants.imageSize)
            Text(model.title)
                .font(.title2)
                .multilineTextAlignment(.center)
            if let buttonTitle = model.buttonTitle, let action = model.action {
                Button(action: action, label: {
                    Text(buttonTitle)
                        .font(.title2)
                })
            }
            Spacer()
        }
    }

    init(model: ErrorModel) {
        self.model = model
    }
}

// MARK: - View Constants
private enum Constants {
    static let imageSize: CGFloat = 100
    static let innerSpacing: CGFloat = 16
}
