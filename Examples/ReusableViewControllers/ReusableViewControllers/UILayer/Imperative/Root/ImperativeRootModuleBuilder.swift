//
//  RootModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct ImperativeRootModuleBuilder {
    func build() -> UIViewController {
        let store = Store<AppState, ImperativeRootAction>(
            reducer: .init { state, _ in
                state
            },
            state: .init(),
            initialAction: .initial
        )

        return ImperativeRootViewController(
            store: store,
            topViewControllerFactory: {
                ImperativeTopModuleBuilder().build(
                    storeCreator: store
                )
            },
            bottomViewControllerFactory: {
                ImperativeBottomModuleBuilder().build(
                    storeCreator: store
                )
            }
        )
    }
}
