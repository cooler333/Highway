//
//  XCTest+WaitForPrecondition.swift
//  InfiniteScrollTests
//
//  Created by Dmitrii Coolerov on 22.08.2022.
//

import Foundation
import XCTest

extension XCTestCase {

    func wait(
        forPrecondition precondition: @escaping () -> Bool,
        timeout seconds: TimeInterval = 1,
        completion: @escaping () -> Void
    ) {
        let expectation = expectation(description: "precodition")

        let countPerSecond: TimeInterval = 100
        let maxIterations = seconds * countPerSecond

        wait(
            forPrecondition: precondition,
            iteration: 0,
            maxIterations: Int(round(maxIterations)),
            completionQueue: .main,
            completion: { success in
                if !success {
                    // swiftlint:disable:next line_length
                    XCTFail("Asynchronous wait failed: Exceeded timeout of \(seconds) seconds, with unfulfilled expectation")
                }
                completion()
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: seconds * 2)
    }

    private func wait(
        forPrecondition precondition: @escaping () -> Bool,
        iteration: Int,
        maxIterations: Int,
        completionQueue: DispatchQueue,
        completion: @escaping (Bool) -> Void
    ) {
        let result = precondition()
        if result == true {
            completion(true)
            return
        }

        if iteration + 1 == maxIterations {
            completion(false)
            return
        }

        completionQueue.asyncAfter(deadline: .now() + 0.01) {
            self.wait(
                forPrecondition: precondition,
                iteration: iteration + 1,
                maxIterations: maxIterations,
                completionQueue: completionQueue,
                completion: completion
            )
        }
    }
}
