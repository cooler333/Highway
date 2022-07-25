//
//  ResultModuleBuilder.swift
//  SocketPingPong
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct ResultModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S
    ) -> UIViewController where S.State == AppState {
        let store = storeCreator.createChildStore(
            reducer: .init { state, _ in
                state
            },
            initialAction: ResultFeature.Action.initial
        )
        return ResultViewController(store: store)
    }
}
