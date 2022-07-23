//
//  SubstateTests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import XCTest
@testable import Highway

class SubstateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMutation() throws {
        struct State: Equatable {
            struct SubState: Equatable {
                var subfoo: String = "start subfoo"
                var subbar: Int = 1000
            }

            var foo: String = "start foo"
            var bar: Int = 0
            var substate: SubState = .init()
        }

        enum Action {
            case initial
            case syncAction
            case foo
            case bar
            case final
        }

        enum SubAction {
            case initial
            case syncAction
            case baz
        }

        let finalExpectation = expectation(description: "final")

        let store = Store<State, Action>(
            reducer: Reducer<State, Action> { state, action in
                var state = state
                state.foo += ", \(action)"
                state.bar += 1
                return state
            },
            state: .init(),
            initialAction: .initial,
            middleware: [createMiddleware({ dispatch, getState, action in
                if action == .final {
                    finalExpectation.fulfill()
                }
            })]
        )
        store.dispatch(.foo)

        let subStore: Store<State.SubState, SubAction> = store.createChildStore(
            keyPath: \.substate,
            reducer: Reducer<State.SubState, SubAction> { state, action in
                var state = state
                state.subfoo += ", \(action)"
                state.subbar -= 1
                return state
            },
            initialAction: .initial
        )

        store.dispatch(.bar)
        subStore.dispatch(.baz)
        store.dispatch(.bar)

        store.dispatch(.final)
        wait(for: [finalExpectation], timeout: 1)

        let referenceState = State(
            foo: "start foo, initial, foo, bar, bar, final",
            bar: 5,
            substate: .init(
                subfoo: "start subfoo, initial, baz",
                subbar: (1000 - 2) // 998
            )
        )

        XCTAssertEqual(store.state, referenceState)
        XCTAssertEqual(store.state.substate, referenceState.substate)
        XCTAssertEqual(subStore.state, referenceState.substate)
    }

    func testMutation2() throws {
        struct State: Equatable {
            struct SubState: Equatable {
                var subfoo: String = "start subfoo"
                var subbar: Int = 1000
            }

            var foo: String = "start foo"
            var bar: Int = 0
            var substate: SubState = .init()
        }

        enum Action {
            case initial
            case foo
            case bar
            case final
        }

        enum SubAction {
            case initial
            case syncAction
            case baz
        }

        let finalExpectation = expectation(description: "final")

        let store = Store<State, Action>(
            reducer: Reducer<State, Action> { state, action in
                var state = state
                state.foo += ", \(action)"
                state.bar += 1
                return state
            },
            state: .init(),
            initialAction: .initial,
            middleware: [createMiddleware({ dispatch, getState, action in
                if action == .final {
                    finalExpectation.fulfill()
                }
            })]
        )
        store.dispatch(.foo)

        let childStore: Store<State.SubState, SubAction> = store.createChildStore(
            keyPath: \.substate,
            reducer: Reducer<State.SubState, SubAction> { state, action in
                var state = state
                state.subfoo += ", \(action)"
                state.subbar -= 1
                return state
            },
            initialAction: .initial
        )

        store.dispatch(.bar)
        childStore.dispatch(.baz)
        store.dispatch(.bar)

        store.dispatch(.final)

        wait(for: [finalExpectation], timeout: 1)

        let referenceState = State.SubState(
            subfoo: "start subfoo, initial, baz",
            subbar: (1000 - 2) // 998
        )
        XCTAssertEqual(childStore.state, referenceState)
    }

    func testMutation3() throws {
        struct State: Equatable {
            struct SubState: Equatable {
                var subfoo: String = "start subfoo"
                var subbar: Int = 1000
            }

            var foo: String = "start foo"
            var bar: Int = 0
            var substate: SubState = .init()
        }

        enum Action {
            case initial
            case foo
            case bar
            case final
        }

        enum SubAction {
            case initial
            case syncAction
            case baz
            case final
        }

        enum SubAction2 {
            case initial2
            case syncAction2
            case baz2
            case final
        }

        let finalExpectation = expectation(description: "final")

        let store = Store<State, Action>(
            reducer: .init { state, action in
                var state = state
                state.foo += ", \(action)"
                state.bar += 1
                return state
            },
            state: .init(),
            initialAction: .initial,
            middleware: [createMiddleware({ dispatch, getState, action in
                if action == .final {
                    finalExpectation.fulfill()
                }
            })]
        )
        store.dispatch(.foo)

        let childStore: Store<State.SubState, SubAction> = store.createChildStore(
            keyPath: \.substate,
            reducer: Reducer<State.SubState, SubAction> { state, action in
                var state = state
                state.subfoo += ", \(action)"
                state.subbar -= 1
                return state
            },
            initialAction: .initial
        )

        let childStore2: Store<State.SubState, SubAction2> = store.createChildStore(
            keyPath: \.substate,
            reducer: Reducer<State.SubState, SubAction2> { state, action in
                var state = state
                state.subfoo += ", \(action)"
                return state
            },
            initialAction: .initial2
        )

        store.dispatch(.bar)
        childStore.dispatch(.baz)
        store.dispatch(.bar)

        store.dispatch(.final)

        let referenceState = State(
            foo: "start foo, initial, foo, bar, bar, final",
            bar: 4,
            substate: .init(
                subfoo: "start subfoo, initial, initial2, baz",
                subbar: (1000 - 2) // 998
            )
        )

        wait(for: [finalExpectation], timeout: 1)

        XCTAssertEqual(store.state.substate, referenceState.substate)
        XCTAssertEqual(childStore.state, referenceState.substate)
        XCTAssertEqual(childStore2.state, referenceState.substate)
    }

    func testMutationNoKeypth() throws {
        struct State: Equatable {
            var foo = "start foo"
            var bar = 0
        }

        enum Action {
            case initial
            case syncAction
            case foo
            case bar
            case final
        }

        enum SubAction {
            case initial
            case syncAction
            case baz
        }

        let finalExpectation = expectation(description: "final")
        let store = Store<State, Action>(
            reducer: Reducer<State, Action> { state, action in
                var state = state
                state.foo += ", \(action)"
                state.bar += 1
                return state
            },
            state: .init(),
            initialAction: .initial,
            middleware: [createMiddleware({ dispatch, getState, action in
                if action == .final {
                    finalExpectation.fulfill()
                }
            })]
        )
        store.dispatch(.foo)

        let subStore: Store<State, SubAction> = store.createChildStore(
            reducer: Reducer<State, SubAction> { state, action in
                var state = state
                state.foo += ", \(action)"
                state.bar += 1
                return state
            },
            initialAction: .initial
        )

        store.dispatch(.bar)
        subStore.dispatch(.baz)
        store.dispatch(.bar)

        store.dispatch(.final)

        wait(for: [finalExpectation], timeout: 1)

        let referenceState = State(
            foo: "start foo, initial, foo, initial, bar, baz, bar, final",
            bar: 7
        )

        XCTAssertEqual(store.state, referenceState)
    }
}
