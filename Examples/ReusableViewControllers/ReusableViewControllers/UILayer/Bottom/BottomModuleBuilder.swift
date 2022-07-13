//
//  BottomModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

struct BottomModuleBuilder {
    func build<S: StoreCreator>(
        storeCreator: S
    ) -> UIViewController where S.State == AppState {
        let store = storeCreator.createChildStore(
            reducer: BottomFeature.reducer(),
            initialAction: .initial
        )
        let proxy = BottomProxy(store: store)
        return ReusableViewController(output: proxy)
    }
}
