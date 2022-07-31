//
//  RootModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct ViewStoreRootModuleBuilder {
    func build() -> UIViewController {
        let store = Store<AppState, ViewStoreRootAction>(
            reducer: .init { state, _ in
                state
            },
            state: .init(),
            initialAction: .initial
        )

        return ViewStoreRootViewController(
            store: store,
            topViewControllerFactory: {
                ViewStoreTopModuleBuilder().build(
                    storeCreator: store
                )
            },
            bottomViewControllerFactory: {
                ViewStoreBottomModuleBuilder().build(
                    storeCreator: store
                )
            }
        )
    }
}
