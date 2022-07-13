//
//  BottomProxy.swift
//  ReusableViewControllers
//
//  Created by Dmitrii Coolerov on 13.07.2022.
//

import Foundation
import Highway

final class BottomProxy {
    let store: Store<AppState, BottomFeature.Action>

    init(
        store: Store<AppState, BottomFeature.Action>
    ) {
        self.store = store
    }
}

extension BottomProxy: ReusableViewOutput {
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
