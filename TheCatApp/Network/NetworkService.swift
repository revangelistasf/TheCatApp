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
        let urlRequest = try makeRequest(endpoint)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        try handle(urlResponse: urlResponse)
        return data
    }

    private func makeRequest(_ endpoint: Endpoint) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = endpoint.header
        return request
    }

    private func handle(urlResponse: URLResponse) throws {
        guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        switch httpUrlResponse.statusCode {
        case 200...299:
            break
        case 400...499:
            throw NetworkError.clientError(httpUrlResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(httpUrlResponse.statusCode)
        default:
            throw NetworkError.generic
        }
    }
}
