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
            reducer: .init { state, _ in
                state
            },
            state: .init(),
            initialAction: .initial
        )

        return RootViewController(
            store: store,
            topViewControllerFactory: {
                TopModuleBuilder().build(
                    storeCreator: store
                )
            },
            bottomViewControllerFactory: {
                BottomModuleBuilder().build(
                    storeCreator: store
                )
            }
        )
    }
}
