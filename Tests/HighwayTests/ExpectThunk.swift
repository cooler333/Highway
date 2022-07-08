//
//  ExpectThunk.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import XCTest
@testable import Highway

private struct ExpectThunkAssertion<T> {
    fileprivate let associated: T
    private let description: String
    private let file: StaticString
    private let line: UInt

    init(description: String, file: StaticString, line: UInt, associated: T) {
        self.associated = associated
        self.description = description
        self.file = file
        self.line = line
    }

    fileprivate func failed() {
        XCTFail(description, file: file, line: line)
    }
}

public class ExpectThunk<State, Action: Equatable> {
    private var dispatch: Dispatch<Action> {
        return { action in
            self.dispatched.append(action)
            guard self.dispatchAssertions.isEmpty == false else {
                return
            }
            self.dispatchAssertions.remove(at: 0).associated(action)
        }
    }
    private var dispatchAssertions = [ExpectThunkAssertion<Dispatch<Action>>]()
    public var dispatched = [Action]()
    private var getState: () -> State {
        return {
            if self.getStateAssertions.isEmpty {
                fatalError()
            } else {
                return self.getStateAssertions.removeFirst().associated
            }
        }
    }
    private var getStateAssertions = [ExpectThunkAssertion<State>]()
    private let thunk: Thunk<State, Action, Void>
    private let initialAction: Action

    public init(_ thunk: Thunk<State, Action, Void>, initialAction: Action) {
        self.thunk = thunk
        self.initialAction = initialAction
    }
}

extension ExpectThunk {
    public func dispatches(
        _ expected: Action,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        dispatchAssertions.append(
            ExpectThunkAssertion(
                description: "Unfulfilled dispatches: \(expected)",
                file: file,
                line: line
            ) { received in
                XCTAssert(
                    received == expected,
                    "Dispatched action does not equal expected: \(received) \(expected)",
                    file: file,
                    line: line
                )
            }
        )
        return self
    }

    public func dispatches(
        file: StaticString = #file,
        line: UInt = #line,
        dispatch assertion: @escaping Dispatch<Action>
    ) -> Self {
        dispatchAssertions.append(
            ExpectThunkAssertion(
                description: "Unfulfilled dispatches: dispatch assertion",
                file: file,
                line: line,
                associated: assertion
            )
        )
        return self
    }
}

extension ExpectThunk {
    public func getsState(
        _ state: State,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        getStateAssertions.append(
            ExpectThunkAssertion(
                description: "Unfulfilled getsState: \(state)",
                file: file,
                line: line,
                associated: state
            )
        )
        return self
    }
}

extension ExpectThunk {
    @discardableResult
    public func wait(timeout seconds: TimeInterval = 1,
                     file: StaticString = #file,
                     line: UInt = #line,
                     description: String = "\(ExpectThunk.self)") -> Self {
        let expectation = XCTestExpectation(description: description)
        defer {
            if XCTWaiter().wait(for: [expectation], timeout: seconds) != .completed {
                XCTFail("Asynchronous wait failed: unfulfilled dispatches", file: file, line: line)
            }
            failLeftovers()
        }
        let dispatch: Dispatch<Action> = {
            self.dispatch($0)
            if self.dispatchAssertions.isEmpty == true {
                expectation.fulfill()
            }
        }
        createThunkMiddleware(
            thunk: thunk,
            action: initialAction
        )(dispatch, getState(), initialAction)
        return self
    }

    private func failLeftovers() {
        dispatchAssertions.forEach { $0.failed() }
        getStateAssertions.forEach { $0.failed() }
    }
}
