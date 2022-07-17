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
    func build() -> UIViewController {
        let store = Store<AppState, RootAction>(
            reducer: .init({ state, action in
                switch action {
                case .initial:
                    return state

                case .setOn:
                    var state = state
                    state.isOn = true
                    return state

                case .setOff:
                    var state = state
                    state.isOn = false
                    return state

                case .reset:
                    var state = state
                    state.shouldReset = true
                    return state

                case .resetted:
                    var state = state
                    state.shouldReset = false
                    return state
                }
            }),
            state: .init(),
            initialAction: .initial
        )

        return RootViewController(
            store: store
        )
    }
}
