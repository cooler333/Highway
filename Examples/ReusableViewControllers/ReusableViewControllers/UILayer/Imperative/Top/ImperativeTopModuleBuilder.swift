//
//  TopModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct ImperativeTopModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S
    ) -> UIViewController where S.State == AppState {
        let store = storeCreator.createChildStore(
            reducer: ImperativeTopFeature.reducer(),
            initialAction: .initial
        )
        let proxy = ImperativeTopProxy(store: store)
        return ImperativeReusableViewController(output: proxy)
    }
}
