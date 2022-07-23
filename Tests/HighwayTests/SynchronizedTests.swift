//
//  SynchronizedTests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import XCTest
/**
 @testable import for testing of `Utils.Synchronized`
 */
@testable import Highway

class SynchronizedTests: XCTestCase {
    private let iterations = 100 // 1_000_000
    private let writeMultipleOf = 10 // 1000
}

extension SynchronizedTests {
    func testSharedVariable() {
        DispatchQueue.concurrentPerform(iterations: iterations) { _ in
            Database.shared.set(key: "test", value: true)
        }
    }
    private class Database {
        static let shared = Database()
        private var data = Synchronized<[String: Any]>([:])
        func get(key: String) -> Any? {
            return data.value { $0[key] }
        }
        func set(key: String, value: Any) {
            data.value { $0[key] = value }
        }
    }
}

extension SynchronizedTests {
    func testWritePerformance() {
        var temp = Synchronized<Int>(0)
        measure {
            temp.value { $0 = 0 } // Reset
            DispatchQueue.concurrentPerform(iterations: iterations) { _ in
                temp.value { $0 += 1 }
            }
            XCTAssertEqual(temp.value, iterations)
        }
    }
}

extension SynchronizedTests {
    func testReadPerformance() {
        var temp = Synchronized<Int>(0)
        measure {
            temp.value { $0 = 0 } // Reset
            DispatchQueue.concurrentPerform(iterations: iterations) {
                guard $0 % writeMultipleOf != 0 else { return }
                temp.value { $0 += 1 }
            }
            XCTAssertGreaterThanOrEqual(temp.value, iterations / writeMultipleOf)
        }
    }
}

extension SynchronizedTests {
    func testActionPerformance() {
        struct CounterState: Equatable {
            var count: Int = 0
        }
        enum Action {
            case initial
            case other
            case final
        }

        measure {
            let finalExpectation = expectation(description: "final")
            let store = Store<CounterState, Action>(
                reducer: .init({ state, action in
                    switch action {
                    case .initial:
                        return state

                    case .other:
                        var state = state
                        state.count += 1
                        return state

                    case .final:
                        return state
                    }
                }),
                state: CounterState(),
                initialAction: .initial,
                middleware: [createMiddleware({ dispatch, getState, action in
                    if action == .final {
                        finalExpectation.fulfill()
                    }
                })]
            )

            DispatchQueue.concurrentPerform(iterations: iterations) { iteration in
                store.dispatch(.other)
                if iteration == iterations - 1 {
                    print("OOOOPS", iteration)
                    store.dispatch(.final)
                }
            }
            wait(for: [finalExpectation], timeout: 1)
            XCTAssertEqual(store.state.count, iterations)
        }
    }
}
