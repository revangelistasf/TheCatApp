//
//  NetworkError.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case generic(Int)
    case clientError(Int)
    case serverError(Int)
}
