//
//  MainModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct MainModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S
    ) -> UIViewController where S.State == RootFeature.State {
        let store = storeCreator.createChildStore(
            reducer: MainFeature.reducer(),
            initialAction: .initial
        )

        return MainViewController(
            store: store
        )
    }
}
