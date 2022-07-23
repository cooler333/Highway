//
//  SubscriptionTests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 08.07.2022.
//

import XCTest
@testable import Highway

class SubscriptionTests: XCTestCase {

    func testListnerCall() throws {
        struct State: Equatable {
            struct Inner: Equatable {
                struct Inner2: Equatable {
                    var c = ""
                }
                var b = ""
                var inner2 = Inner2()
            }
            var a = ""
            var inner = Inner()
        }

        enum Action {
            case initial
            case mutate
            case noOperation
        }

        let store = Store<State, Action>(
            reducer: .init({ state, action in
                return state
            }),
            state: .init(),
            initialAction: .initial
        )

        var callCount = 0
        store.subscribe(listener: { _ in
            callCount += 1
        })

        let childStore = store.createChildStore(
            keyPath: \.inner,
            reducer: Reducer<State.Inner, Action>({ state, action in
                return state
            }),
            initialAction: .initial
        )

        let finalExpectation = expectation(description: "final")

        let childStore2 = childStore.createChildStore(
            keyPath: \.inner2,
            reducer: Reducer<State.Inner.Inner2, Action>({ state, action in
                switch action {
                case .initial:
                    return state
                case .noOperation:
                    return state
                case .mutate:
                    var state = state
                    state.c = "hi"
                    return state
                }
            }),
            initialAction: .initial,
            middleware: [createMiddleware({ dispatch, getState, action in
                if action == .noOperation {
                    finalExpectation.fulfill()
                }
            })]
        )

        childStore2.dispatch(.initial)
        childStore2.dispatch(.mutate)
        childStore2.dispatch(.noOperation)

        wait(for: [finalExpectation], timeout: 1)

        XCTAssertEqual(store.state.inner.inner2.c, "hi")
        XCTAssertEqual(callCount, 1)
    }

    func testListnerCallNoKeyPath() throws {
        struct State: Equatable {
            struct Inner: Equatable {
                struct Inner2: Equatable {
                    var c = ""
                }
                var b = ""
                var inner2 = Inner2()
            }
            var a = ""
            var inner = Inner()
        }

        enum Action {
            case initial
            case mutate
            case noOperation
        }

        let store = Store<State, Action>(
            reducer: .init({ state, action in
                return state
            }),
            state: .init(),
            initialAction: .initial
        )

        var callCount = 0
        store.subscribe(listener: { _ in
            callCount += 1
        })

        let childStore = store.createChildStore(
            reducer: Reducer<State, Action>({ state, action in
                return state
            }),
            initialAction: .initial
        )

        let finalExpectation = expectation(description: "final")

        let childStore2 = childStore.createChildStore(
            reducer: Reducer<State, Action>({ state, action in
                switch action {
                case .initial:
                    return state
                case .noOperation:
                    return state
                case .mutate:
                    var state = state
                    state.inner.inner2.c = "hi"
                    return state
                }
            }),
            initialAction: .initial,
            middleware: [createMiddleware({ dispatch, getState, action in
                if action == .noOperation {
                    finalExpectation.fulfill()
                }
            })]
        )

        childStore2.dispatch(.initial)
        childStore2.dispatch(.mutate)
        childStore2.dispatch(.noOperation)

        wait(for: [finalExpectation], timeout: 1)

        XCTAssertEqual(store.state.inner.inner2.c, "hi")
        XCTAssertEqual(callCount, 1)
    }

    func testUnsubscription() throws {
        struct State: Equatable {
            struct Inner: Equatable {
                struct Inner2: Equatable {
                    var c = ""
                }
                var b = ""
                var inner2 = Inner2()
            }
            var a = ""
            var inner = Inner()
        }

        enum Action {
            case initial
            case mutate
            case noOperation
        }

        let finalExpectation = expectation(description: "final")

        let store = Store<State, Action>(
            reducer: Reducer<State, Action>({ state, action in
                return state
            }),
            state: .init(),
            initialAction: .initial
        )

        var callCount = 0
        let subscription = store.subscribe(listener: { _ in
            callCount += 1
        })

        let childStore = store.createChildStore(
            keyPath: \.inner,
            reducer: Reducer<State.Inner, Action>({ state, action in
                switch action {
                case .initial:
                    return state
                case .noOperation:
                    return state

                case .mutate:
                    var state = state
                    state.inner2.c = "hi"
                    return state
                }
            }),
            initialAction: .initial,
            middleware: [createMiddleware({ dispatch, getState, action in
                if action == .noOperation {
                    finalExpectation.fulfill()
                }
            })]
        )

        store.unsubscribe(subscription)

        childStore.dispatch(.initial)
        childStore.dispatch(.mutate)
        childStore.dispatch(.noOperation)

        wait(for: [finalExpectation], timeout: 1)

        XCTAssertEqual(store.state.inner.inner2.c, "hi")
        XCTAssertEqual(callCount, 0)
    }

    func testEquitable() throws {
        struct State {}

        let sub1 = Subscription<State> { _ in }
        let sub2 = Subscription<State> { _ in }

        XCTAssertNotEqual(sub1, sub2)
    }
}
