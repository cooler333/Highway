//
//  AutomaticallySkipRepeatsTests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import XCTest
@testable import Highway

class AutomaticallySkipRepeatsTests: XCTestCase {

    private var store: Store<State, ChangeAgeAction>!
    private var subscriptionUpdates: Int = 0

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        store = Store<State, ChangeAgeAction>(
            reducer: reducer,
            state: State(age: 0, name: ""),
            initialAction: .initial
        )
        subscriptionUpdates = 0
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        store = nil
        subscriptionUpdates = 0
        super.tearDown()
    }

    func testInitialSubscriptionWithRegularSubstateSelection() {
        store.subscribe({ [unowned self] _ in
            self.subscriptionUpdates += 1
        })
        XCTAssertEqual(self.subscriptionUpdates, 0)
    }

    func testDispatchUnrelatedActionWithExplicitSkipRepeatsWithRegularSubstateSelection() {
        store.subscribe({ [unowned self] _ in
            self.subscriptionUpdates += 1
        })
        XCTAssertEqual(self.subscriptionUpdates, 0)
        store.dispatch(.changeAge(30))
        XCTAssertEqual(self.subscriptionUpdates, 1)
    }
}

private struct State {
    let age: Int
    let name: String
}

extension State: Equatable {
    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.age == rhs.age && lhs.name == rhs.name
    }
}

enum ChangeAgeAction {
    case initial
    case changeAge(_ newAge: Int)
}

private let initialState = State(age: 29, name: "Daniel")

private func reducer(state: State?, action: ChangeAgeAction) -> State {
    let defaultState = state ?? initialState
    switch action {
    case .changeAge(let newAge):
        return State(age: newAge, name: defaultState.name)

    default:
        return defaultState
    }
}
