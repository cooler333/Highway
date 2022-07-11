//
//  RootFeature.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway

enum CounterFeature {
    enum Action: Equatable {
        case initial
        case increment
        case decrement
        case save
        case saved(success: Bool)
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

    static func middlewares(
        stateStorage: StateStorageProtocol
    ) -> [Middleware<AppState, Action>] {
        return [
            createMiddleware(
                environment: stateStorage,
                { dispatch, getState, action, environment in
                    guard action == .save else { return }
                    let state = getState()
                    DispatchQueue.global(
                        qos: .background
                    ).asyncAfter(
                        deadline: .now() + 2,
                        execute: {
                            stateStorage.save(state)
                            dispatch(.saved(success: true))
                        }
                    )
                }
            )
        ]
    }
}
