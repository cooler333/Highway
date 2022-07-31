//
//  TopProxy.swift
//  ReusableViewControllers
//
//  Created by Dmitrii Coolerov on 13.07.2022.
//

import Foundation
import Highway

final class ImperativeTopProxy {
    let store: Store<AppState, ImperativeTopFeature.Action>

    private unowned var input: ImperativeReusableViewInput!

    init(
        store: Store<AppState, ImperativeTopFeature.Action>
    ) {
        self.store = store

        store.subscribe { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                self?.input.updateValue()
            }
        }
    }
}

extension ImperativeTopProxy: ImperativeReusableViewOutput {
    func increment() {
        store.dispatch(.increment)
    }

    func decrement() {
        store.dispatch(.decrement)
    }

    func getValue() -> Int {
        store.state.count
    }

    func setupInput(_ input: ImperativeReusableViewInput) {
        self.input = input
    }
}
