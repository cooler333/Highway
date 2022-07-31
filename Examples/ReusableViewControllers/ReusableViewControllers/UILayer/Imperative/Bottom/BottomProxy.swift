//
//  BottomProxy.swift
//  ReusableViewControllers
//
//  Created by Dmitrii Coolerov on 13.07.2022.
//

import Foundation
import Highway

final class ImperativeBottomProxy {
    let store: Store<AppState, ImperativeBottomFeature.Action>

    private unowned var input: ImperativeReusableViewInput!

    init(
        store: Store<AppState, ImperativeBottomFeature.Action>
    ) {
        self.store = store

        store.subscribe { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                self?.input.updateValue()
            }
        }
    }
}

extension ImperativeBottomProxy: ImperativeReusableViewOutput {
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
