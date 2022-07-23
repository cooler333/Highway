//
//  StoreTests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import XCTest
@testable import Highway

class StoreTests: XCTestCase {

    func testInit() {
        struct CounterState: Equatable {
            var count: Int = 0
        }
        enum Action {
            case initial
            case other
        }

        class MockReducer {
            var calledWithAction: [Action] = []
            func handleAction(state: CounterState, action: Action) -> CounterState {
                calledWithAction.append(action)
                return state
            }
        }

        let finalExpectation = expectation(description: "final")

        let reducer = MockReducer()
        let store = Store<CounterState, Action>(
            reducer: Reducer<CounterState, Action>(reducer.handleAction),
            state: CounterState(),
            initialAction: .initial,
            middleware: [createMiddleware({ dispatch, getState, action in
                if action == .initial {
                    finalExpectation.fulfill()
                }
            })]
        )
        _ = store.state

        wait(for: [finalExpectation], timeout: 3)

        let firstAction = reducer.calledWithAction[0]
        switch firstAction {
        case .initial:
            break
        default:
            XCTFail("First action must be `.initial`")
        }
    }
}
