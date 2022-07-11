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
                })
            ]
        )
        store.dispatch(.first)

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
                createThunkMiddleware(thunk: thunk, action: .first)
            ]
        )
        store.dispatch(.first)

        XCTAssertEqual(store.state.count, 3)
    }

}
