//
//  PerformanceTests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import XCTest
@testable import Highway

final class PerformanceTests: XCTestCase {
    
    func testChildStoresStateMutation() {
        struct State: Equatable {
            struct Inner: Equatable {
                struct Inner2: Equatable {
                    var a = ""
                    var b = ""
                    var c = ""
                    var d = ""
                    var e = ""
                    var f = ""
                    var g = ""
                    var h = ""
                    var i = ""
                }
                var a = ""
                var b = ""
                var c = ""
                var d = ""
                var e = ""
                var f = ""
                var g = ""
                var h = ""
                var i = ""
                
                var inner2 = Inner2()
            }
            var a = ""
            var b = ""
            var c = ""
            var d = ""
            var e = ""
            var f = ""
            var g = ""
            var h = ""
            var i = ""
            
            var inner = Inner()
        }
        
        enum Action {
            case initial
            case mutate
        }
        
        let store = Store<State, Action>(
            reducer: { state, action in
                return state
            },
            state: .init(),
            initialAction: .initial
        )
        
        let stores = Array([0...1000]).map { _ in
            return store.createChildStore(
                keyPath: \.inner,
                reducer: { (state: State.Inner, action: Action) in
                    return state
                },
                initialAction: .initial
            )
        }
        let innerStore = stores.last!
        
        let innerStores = Array([0...1000]).map { _ in
            return innerStore.createChildStore(
                keyPath: \.inner2,
                reducer: { (state: State.Inner.Inner2, action: Action) in
                    switch action {
                    case .initial:
                        return state
                    case .mutate:
                        var state = state
                        state.i = "hi"
                        return state
                    }
                },
                initialAction: .initial
            )
        }

        measure {
            innerStores.last!.dispatch(.mutate)
        }
        
        XCTAssertEqual(store.state.inner.inner2.i, "hi")
    }
    
    func testNotify() {
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
        _ = subscribers.map(store.subscribe)
        measure {
            store.dispatch(.noOpAction)
        }
    }

    func testSubscribe() {
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
        measure {
            _ = subscribers.map(store.subscribe)
        }
    }
}
