//
//  BottomFeature.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway

enum BottomFeature {
    enum Action: Equatable {
        case initial
        case increment
        case decrement
    }

    static func reducer() -> Reducer<AppState, Action> {
        return .init { state, action in
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
            }
        }
    }
}
