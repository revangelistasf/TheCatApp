//
//  Breeds.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

enum BreedEndpoint: Endpoint {
    case breeds

    var path: String  {
        switch self {
        case .breeds:
            "/v1/breeds"
        }
    }
}
