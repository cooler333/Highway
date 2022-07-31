//
//  TopModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct ViewStoreTopModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S
    ) -> UIViewController where S.State == AppState {
        let store = storeCreator.createChildStore(
            reducer: ViewStoreTopFeature.reducer(),
            initialAction: .initial
        )
        return ViewStoreReusableViewController(
            viewStore: .init(
                store: store,
                stateMapper: { state in
                    .init(value: "\(state.count)")
                },
                actionMapper: { action in
                    switch action {
                    case .increment:
                        return .increment
                    case .decrement:
                        return .decrement
                    }
                }
            )
        )
    }
}
