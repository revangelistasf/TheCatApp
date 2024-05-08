//
//  ErrorFactory.swift
//  TheCatApp
//
//  Created by revangelista on 08/05/2024.
//

import SwiftUI

enum ErrorViewType: Error {
    case generic
    case clientError
    case serverError
    case emptyFavorites
    case noResults
    case failedToFetchPersistenceData
}

enum ErrorViewFactory {
    static func getErrorView(type: ErrorViewType, action: (() -> Void)? = nil) -> ErrorView {
        ErrorView(model: errorModel(type: type, action: action))
    }

    static func errorModel(type: ErrorViewType, action: (() -> Void)?) -> ErrorModel {
        switch type {
        case .generic:
            return ErrorModel(
                image: .angryCat,
                title: "Sorry! Something went wrong.",
                buttonTitle: "Try Again",
                action: action
            )
        case .clientError:
            return ErrorModel(
                image: .angryCat,
                title: "Something went wrong, contact our support.",
                buttonTitle: "Try Again",
                action: action
            )
        case .serverError:
            return ErrorModel(
                image: .angryCat,
                title: "Something went wrong with server.",
                buttonTitle: "Try Again",
                action: action
            )
        case .emptyFavorites:
            return ErrorModel(image: .sadCat, title: "No favorites added yet.")
        case .noResults:
            return ErrorModel(
                image: .angryCat,
                title: "No results.",
                buttonTitle: "Try Again",
                action: action
            )
        case .failedToFetchPersistenceData:
            return ErrorModel(
                image: .sadCat,
                title: "Something went wrong.",
                buttonTitle: "Try Again",
                action: action
            )
        }
    }
}
