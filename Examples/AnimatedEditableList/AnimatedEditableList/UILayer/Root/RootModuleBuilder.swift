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
        let store = Store<RootFeature.State, RootFeature.Action>(
            reducer: .init { state, _ in
                state
            },
            state: .init(),
            initialAction: .initial
        )

        return RootViewController(
            store: store,
            mainViewControllerFactory: {
                MainModuleBuilder().build(storeCreator: store)
            },
            detailsViewControllerFactory: {
                DetailsModuleBuilder().build(storeCreator: store)
            }
        )
    }
}
