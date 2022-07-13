//
//  TopModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct TopModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S
    ) -> UIViewController where S.State == AppState {
        let store = storeCreator.createChildStore(
            reducer: TopFeature.reducer(),
            initialAction: .initial
        )
        let proxy = TopProxy(store: store)
        return ReusableViewController(output: proxy)
    }
}
