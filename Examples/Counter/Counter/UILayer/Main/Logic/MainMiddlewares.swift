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
            saveMiddleware(stateStorage: stateStorage)
        ]
    }
    
    private static func onChangeSaveMiddleware() -> Middleware<AppState, Action> {
        createMiddleware({ dispatch, getState, action in
            switch action {
            case .increment, .decrement:
                dispatch(.save)
            default:
                break
            }
        })
    }
    
    private static func saveMiddleware(
        stateStorage: StateStorageProtocol
    ) -> Middleware<AppState, Action> {
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
        )
    }
}
