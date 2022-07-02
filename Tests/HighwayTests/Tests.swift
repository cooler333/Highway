//
//  Tests.swift
//  Highway-Unit-HighwayTests
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import XCTest
@testable import Highway

private struct FakeState {}
private enum ThunkAction: Equatable {
    case initial
    case fakeAction
    case anotherFakeAction

    static func == (lhs: ThunkAction, rhs: ThunkAction) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true

        case (.fakeAction, .fakeAction):
            return true

        case (.anotherFakeAction, .anotherFakeAction):
            return true

        default:
            return false
        }
    }
}

private func fakeReducer(state: FakeState?, action: ThunkAction) -> FakeState {
    return state ?? FakeState()
}

class Tests: XCTestCase {

    func testExpectThunkWaits() {
        let thunk = Thunk<FakeState, ThunkAction, Void>(environment: ()) { dispatch, getState, _, _ in
            dispatch(.fakeAction)
            XCTAssertNotNil(getState())
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.5) {
                dispatch(.anotherFakeAction)
                XCTAssertNotNil(getState())
            }
            dispatch(.fakeAction)
        }
        let expectThunk = ExpectThunk<FakeState, ThunkAction>(thunk, initialAction: .initial)
            .dispatches { action in
                switch action {
                case .fakeAction:
                    break
                default:
                    XCTFail("Unexpected action: \(action)")
                }
            }
            .getsState(FakeState())
            .dispatches { action in
                switch action {
                case .fakeAction:
                    break
                default:
                    XCTFail("Unexpected action: \(action)")
                }
            }
            .dispatches(.anotherFakeAction)
            .getsState(FakeState())
            .wait()
        XCTAssertEqual(expectThunk.dispatched.count, 3)
    }
}
