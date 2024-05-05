//
//  Breeds.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

enum BreedEndpoint: Endpoint {
    case breeds(page: Int)

    var path: String  {
        switch self {
        case .breeds:
            "/v1/breeds"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .breeds(let page):
            return [
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }
}
