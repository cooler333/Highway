//
//  RootModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct RootModuleBuilder {
    func build(stateStorage: StateStorageProtocol) -> UIViewController {
        let store = Store<AppState, RootAction>(
            reducer: .init { state, _ in
                state
            },
            state: stateStorage.getState() ?? .init(),
            initialAction: .initial
        )

        return RootViewController(
            store: store,
            mainViewControllerFactory: {
                MainModuleBuilder().build(
                    storeCreator: store,
                    stateStorage: stateStorage
                )
            },
            counterViewControllerFactory: {
                CounterModuleBuilder().build(
                    storeCreator: store,
                    stateStorage: stateStorage
                )
            }
        )
    }
}
