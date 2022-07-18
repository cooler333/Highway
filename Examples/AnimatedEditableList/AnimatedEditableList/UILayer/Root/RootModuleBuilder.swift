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
            reducer: RootFeature.reducer(),
            state: RootFeature.State(),
            initialAction: .initial
        )

        return RootViewController(
            store: store
        )
    }
}
