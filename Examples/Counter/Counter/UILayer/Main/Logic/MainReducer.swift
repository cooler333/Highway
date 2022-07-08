//
//  MainReducer.swift
//  Counter
//
//  Created by Dmitrii Cooler on 08.07.2022.
//

import Foundation
import Highway

extension MainFeature {
    static func reducer() -> Reducer<AppState, Action> {
        return { state, action in
            switch action {
            case .initial:
                return state

            case .increment:
                var state = state
                state.count += 1
                return state

            case .decrement:
                var state = state
                state.count -= 1
                return state

            case .save:
                var state = state
                state.isSaving = true
                return state

            case let .saved(success):
                var state = state
                state.isSaving = false
                state.saved = success
                return state
            }
        }
    }
}
