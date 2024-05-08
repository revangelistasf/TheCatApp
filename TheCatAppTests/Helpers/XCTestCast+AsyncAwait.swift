//
//  XCTestCast+AsyncAwait.swift
//  TheCatAppTests
//
//  Created by revangelista on 08/05/2024.
//

import XCTest

extension XCTestCase {
    var timeout: TimeInterval {
        1.0
    }

    func runAsyncTest(
        file: StaticString = #file,
        line: UInt = #line,
        test: @escaping () async throws -> Void
    ) {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = expectation(description: "waiting")
        Task {
            do {
                try await test()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeout)
        guard let error = thrownError else { return }
        XCTFail("Async await error: \(error)", file: file, line: line)
    }
}
