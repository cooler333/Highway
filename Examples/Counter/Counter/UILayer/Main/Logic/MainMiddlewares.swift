//
//  MainMiddlewares.swift
//  Counter
//
//  Created by Dmitrii Cooler on 08.07.2022.
//

import Foundation
import Highway

extension MainFeature {
    static func middlewares(
        stateStorage: StateStorageProtocol
    ) -> [Middleware<AppState, Action>] {
        return [
            onChangeSaveMiddleware(),
            saveMiddleware(stateStorage: stateStorage),
        ]
    }

    private static func onChangeSaveMiddleware() -> Middleware<AppState, Action> {
        createMiddleware { dispatch, _, action in
            switch action {
            case .increment, .decrement:
                dispatch(.save)
            default:
                break
            }
        }
    }

    private static func saveMiddleware(
        stateStorage: StateStorageProtocol
    ) -> Middleware<AppState, Action> {
        createMiddleware(
            environment: stateStorage,
            { dispatch, getState, action, _ in
                guard action == .save else { return }
                guard var state = getState() else { return }
                state.isSaving = false
                stateStorage.save(state, completion: { result in
                    switch result {
                    case .success:
                        dispatch(.saved(success: true))

                    case let .failure(error):
                        print(error)
                        dispatch(.saved(success: false))
                    }
                })
            }
        )
    }
}
