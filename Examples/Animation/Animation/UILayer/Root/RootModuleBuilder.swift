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
        let store = Store<AppState, RootFeature.Action>(
            reducer: RootFeature.getReducer(),
            state: .init(),
            initialAction: .initial
        )

        return RootViewController(
            store: store
        )
    }
}
