//
//  BottomModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct ImperativeBottomModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S
    ) -> UIViewController where S.State == AppState {
        let store = storeCreator.createChildStore(
            reducer: ImperativeBottomFeature.reducer(),
            initialAction: .initial
        )
        let proxy = ImperativeBottomProxy(store: store)
        return ImperativeReusableViewController(output: proxy)
    }
}
