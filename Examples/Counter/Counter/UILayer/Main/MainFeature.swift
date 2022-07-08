//
//  MainFeature.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway

enum MainFeature {
    enum Action: Equatable {
        case initial
        case increment
        case decrement
        case save
        case saved(success: Bool)
    }

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

    static func middlewares(
        stateStorage: StateStorageProtocol
    ) -> [Middleware<AppState, Action>] {
        return [
            createMiddleware({ dispatch, state, action in
                switch action {
                case .increment, .decrement:
                    dispatch(.save)
                default:
                    break
                }
            }),
            createMiddleware(
                environment: stateStorage,
                { dispatch, state, action, environment in
                    if action == .save {
                        DispatchQueue.global(qos: .background).asyncAfter(
                            deadline: .now() + 2,
                            execute: {
                                let isSuccess = Int.random(in: 0...2) != 0
                                if isSuccess {
                                    stateStorage.save(state)
                                    dispatch(.saved(success: true))
                                } else {
                                    dispatch(.saved(success: false))
                                }
                            }
                        )
                    }
                }
            )
        ]
    }
}
