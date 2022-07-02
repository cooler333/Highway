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

    func testExample() throws {
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
        }
        
        enum SubAction {
            case initial
            case baz
        }
        
        let store = Store<State, Action>(
            reducer: { state, action in
                var state = state
                state.foo += ", \(action)"
                state.bar += 1
                return state
            },
            state: .init(),
            initialAction: .initial
        )
        store.dispatch(.foo)

        let subStore: Store<State.SubState, SubAction> = store.createSubStore(
            reducer: { state, action in
                var state = state
                state.subfoo += ", \(action)"
                state.subbar -= 1
                return state
            },
            subState: \.substate,
            initialAction: .initial,
            middleware: []
        )
        
        store.dispatch(.bar)
        subStore.dispatch(.baz)
        store.dispatch(.bar)
        
        let referenceState = State(
            foo: "start foo, initial, foo, bar, bar",
            bar: 4,
            substate: .init(
                subfoo: "start subfoo, initial, baz",
                subbar: (1000 - 2) // 998
            )
        )
        XCTAssertEqual(store.getState(), referenceState)
    }
}
