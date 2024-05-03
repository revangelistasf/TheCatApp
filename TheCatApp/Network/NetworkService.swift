//
//  NetworkService.swift
//  TheCatApp
//
//  Created by revangelista on 03/05/2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func request(_ endpoint: Endpoint) async throws -> Data
}

final class NetworkService: NetworkServiceProtocol {
    func request(_ endpoint: Endpoint) async throws -> Data {
        guard let urlRequest = makeRequest(endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return data
    }
    
    private func makeRequest(_ endpoint: Endpoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        return request
    }
}
