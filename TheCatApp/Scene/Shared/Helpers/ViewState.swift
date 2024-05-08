//
//  ViewState.swift
//  TheCatApp
//
//  Created by revangelista on 05/05/2024.
//

import Foundation

enum ViewState<Value, StateError: Error> {
    case idle
    case loading
    case loadingNextPage(Value)
    case success(Value)
    case error(StateError)
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

    var error: StateError? {
        if case .error(let stateError) = self {
            return stateError
        }

        return nil
    }

    var isLoading: Bool {
        if case .loading = self {
            return true
        }

        return false
    }

    var isLoadingNextPage: Bool {
        if case .loadingNextPage = self {
            return true
        }

        return false
    }

    var isError: Bool {
        if case .error = self {
            return true
        }

        return false
    }

    var isSuccess: Bool {
        switch self {
        case .success, .loadingNextPage:
            return true
        default:
            return false
        }
    }
}
