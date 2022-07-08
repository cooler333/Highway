//
//  CounterModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct CounterModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S,
        stateStorage: StateStorageProtocol
    ) -> UIViewController where S.State == AppState {
        let store = storeCreator.createChildStore(
            reducer: CounterFeature.reducer(),
            initialAction: .initial,
            middleware: CounterFeature.middlewares(
                stateStorage: stateStorage
            )
        )
        return CounterViewController(store: store)
    }
}
