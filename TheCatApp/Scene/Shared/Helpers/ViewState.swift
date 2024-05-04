//
//  ViewState.swift
//  TheCatApp
//
//  Created by revangelista on 05/05/2024.
//

import Foundation

enum ViewState<Value, Error> {
    case idle
    case loading
    case loadingNextPage(Value)
    case success(Value)
    case error(Error)
}

extension ViewState {
    var value: Value? {
        switch self {
        case .success(let value), .loadingNextPage(let value):
            return value
        default:
            return nil
        }
    }

    var isLoadingNextPage: Bool {
        if case .loadingNextPage = self {
            return true
        }

        return false
    }
}
