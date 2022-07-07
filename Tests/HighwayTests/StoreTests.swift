//
//  StoreTests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import XCTest
@testable import Highway

class StoreTests: XCTestCase {

    /**
     it dispatches an Init action when it doesn't receive an initial state
     */
    func testInit() {
        let reducer = MockReducer()
        _ = Store<CounterState, Action>(
            reducer: reducer.handleAction,
            state: CounterState(),
            initialAction: .initial
        )

        let firstAction = reducer.calledWithAction[0]
        switch firstAction {
        case .initial:
            break
        default:
            XCTFail("First action must be `.initial`")
        }
    }
}

struct CounterState: Equatable {
    var count: Int = 0
}

class MockReducer {

    var calledWithAction: [Action] = []

    func handleAction(state: CounterState, action: Action) -> CounterState {
        calledWithAction.append(action)

        return state
    }

}
