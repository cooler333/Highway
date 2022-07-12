//
//  PingPongModuleBuilder.swift
//  SocketPingPong
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct PingPongModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S
    ) -> UIViewController where S.State == AppState {
        let store = storeCreator.createChildStore(
            reducer: PingPongFeature.reducer(),
            initialAction: .initial,
            middleware: PingPongFeature.middlewares(
                environment: .init()
            )
        )
        return PingPongViewController(store: store)
    }
}
