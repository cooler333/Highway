//
//  MainModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct MainModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S,
        stateStorage: StateStorageProtocol
    ) -> UIViewController where S.State == AppState {
        let store = storeCreator.createChildStore(
            reducer: MainFeature.reducer(),
            initialAction: .initial,
            middleware: MainFeature.middlewares(
                stateStorage: stateStorage
            )
        )
        return MainViewController(store: store)
    }
}
