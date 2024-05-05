//
//  TitleWithParagraphView.swift
//  TheCatApp
//
//  Created by revangelista on 06/05/2024.
//

import SwiftUI

struct TitleWithParagraphView: View {
    let viewModel: TitleWithParagraphViewModel

    var body: some View {
        VStack(spacing: 8) {
            Text(viewModel.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .foregroundStyle(.titleText)
            Text(viewModel.description)
                .foregroundStyle(.paragraphText)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
