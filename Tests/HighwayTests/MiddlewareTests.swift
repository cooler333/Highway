//
//  MiddlewareTests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 08.07.2022.
//

import XCTest
@testable import Highway

class MiddlewareTests: XCTestCase {

    func testExample() throws {
        struct CounterState: Equatable {
            var count: Int = 0
        }
        enum Action: Equatable {
            case initial
            case first
            case second
        }

        let finalExpectation = expectation(description: "final")

        let store = Store<CounterState, Action>(
            reducer: .init({ state, action in
                switch action {
                case .initial:
                    return state
                case .first:
                    var state = state
                    state.count += 1
                    return state
                case .second:
                    var state = state
                    state.count += 2
                    return state
                }
            }),
            state: CounterState(),
            initialAction: .initial,
            middleware: [
                createMiddleware({ dispatch, getState, action in
                    if action == .first {
                        dispatch(.second)
                    }
                }),
                createMiddleware({ dispatch, getState, action in
                    if action == .second {
                        finalExpectation.fulfill()
                    }
                })
            ]
        )
        store.dispatch(.first)

        wait(for: [finalExpectation], timeout: 1)

        XCTAssertEqual(store.state.count, 3)
    }

    func testExample2() throws {
        struct CounterState: Equatable {
            var count: Int = 0
        }
        enum Action: Equatable {
            case initial
            case first
            case second
        }

        let finalExpectation = expectation(description: "final")

        let thunk: Thunk<CounterState, Action, Void> = Thunk { dispatch, getState, action, env in
            dispatch(.second)
        }
        let store = Store<CounterState, Action>(
            reducer: .init({ state, action in
                switch action {
                case .initial:
                    return state
                case .first:
                    var state = state
                    state.count += 1
                    return state
                case .second:
                    var state = state
                    state.count += 2
                    return state
                }
            }),
            state: CounterState(),
            initialAction: .initial,
            middleware: [
                createThunkMiddleware(thunk: thunk, action: .first),
                createMiddleware({ dispatch, getState, action in
                    if action == .second {
                        finalExpectation.fulfill()
                    }
                })
            ]
        )
        store.dispatch(.first)

        wait(for: [finalExpectation], timeout: 1)

        XCTAssertEqual(store.state.count, 3)
    }

    func testExample3() throws {
        struct CounterState: Equatable {
            var count: Int = 0
        }
        enum Action: Equatable {
            case initial
            case first
            case second
        }

        let finalExpectation = expectation(description: "final")

        let thunk: Thunk<CounterState, Action, Void> = Thunk { dispatch, getState, action, env in
            guard action == .first else { return }
            dispatch(.second)
        }
        let store = Store<CounterState, Action>(
            reducer: .init({ state, action in
                switch action {
                case .initial:
                    return state
                case .first:
                    var state = state
                    state.count += 1
                    return state
                case .second:
                    var state = state
                    state.count += 2
                    return state
                }
            }),
            state: CounterState(),
            initialAction: .initial,
            middleware: [
                createThunkMiddleware(thunk: thunk),
                createMiddleware({ dispatch, getState, action in
                    if action == .second {
                        finalExpectation.fulfill()
                    }
                })
            ]
        )
        store.dispatch(.first)

        wait(for: [finalExpectation], timeout: 1)

        XCTAssertEqual(store.state.count, 3)
    }
}
