//
//  TopProxy.swift
//  ReusableViewControllers
//
//  Created by Dmitrii Coolerov on 13.07.2022.
//

import Foundation
import Highway

final class TopProxy {
    let store: Store<AppState, TopFeature.Action>

    init(
        store: Store<AppState, TopFeature.Action>
    ) {
        self.store = store
    }
}

extension TopProxy: ReusableViewOutput {
    func increment() {
        store.dispatch(.increment)
    }

    func decrement() {
        store.dispatch(.decrement)
    }

    func getValue() -> Int {
        store.state.count
    }
}
