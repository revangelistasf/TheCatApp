//
//  MockedNetworkService.swift
//  TheCatAppTests
//
//  Created by revangelista on 08/05/2024.
//

import Foundation
@testable import TheCatApp

class MockedNetworkService: NetworkServiceProtocol {
    var onRequest: ((_ endpoint: Endpoint) async throws -> Data)?
    func request(_ endpoint: Endpoint) async throws -> Data {
        guard let request = try await onRequest?(endpoint) else { throw NetworkError.invalidResponse }
        return request
    }
}
