//
//  RootFeature.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway

enum RootFeature {

    enum Action {
        case initial
        case setOn(id: String)
        case setOff(id: String)
        case resetAll
        case resetted
    }

    static func getReducer() -> Reducer<AppState, Action> {
        .init { state, action in
            switch action {
            case .initial:
                var state = state
                state.data = [
                    .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                    .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                    .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                    .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                    .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                    .segmentData(.init(id: UUID().uuidString, segments: ["foo", "bar", "baz"], selectedIndex: 0, state: .normal)),
                ]
                return state

            case let .setOn(value):
                var state = state
                state.data = state.data.map { data in
                    switch data {
                    case let .boolData(boolData):
                        var boolData = boolData
                        boolData.isOn = true
                        if boolData.id == value {
                            boolData.state = .normal
                        } else {
                            boolData.state = .disabled
                        }
                        return .boolData(boolData)

                    case let .segmentData(segmentData):
                        return .segmentData(segmentData)
                    }
                }
                return state

            case let .setOff(value):
                var state = state
                state.data = state.data.map { data in
                    switch data {
                    case let .boolData(boolData):
                        var boolData = boolData
                        boolData.isOn = false
                        if boolData.id == value {
                            boolData.state = .normal
                        } else {
                            boolData.state = .disabled
                        }
                        return .boolData(boolData)

                    case let .segmentData(segmentData):
                        return .segmentData(segmentData)
                    }
                }
                return state

            case .resetAll:
                var state = state
                state.shouldReset = true
                return state

            case .resetted:
                var state = state
                state.shouldReset = false
                return state
            }
        }
    }
}
