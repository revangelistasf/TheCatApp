//
//  Endpoint.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var header: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.thecatapi.com"
    }

    var header: [String: String]? {
        return [
            "Content-Tye": "application/json"
        ]
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
}
