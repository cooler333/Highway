//
//  RootModuleBuilder.swift
//  SocketPingPong
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
                return state
            }),
            state: .init(),
            initialAction: .initial
        )

        return RootViewController(
            store: store,
            resultViewControllerFactory: {
                ResultModuleBuilder().build(
                    storeCreator: store
                )
            },
            pingPongViewControllerFactory: {
                PingPongModuleBuilder().build(
                    storeCreator: store
                )
            }
        )
    }
}
