//
//  PerformanceTests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import XCTest
@testable import Highway

final class PerformanceTests: XCTestCase {
    struct MockState: Equatable {}
    enum MockAction {
        case initial
        case noOpAction
    }

    let subscribers: [(MockState) -> Void] = (0..<3000).map { _ in return { _ in } }
    let store = Store<MockState, MockAction>(
        reducer: { state, _ in return state },
        state: MockState(),
        initialAction: .initial
    )

    func testNotify() {
        _ = self.subscribers.map(self.store.subscribe)
        self.measure {
            self.store.dispatch(.noOpAction)
        }
    }

    func testSubscribe() {
        self.measure {
            _ = self.subscribers.map(self.store.subscribe)
        }
    }
}
