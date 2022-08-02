//
//  RootSwiftUIModuleBuilder.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit
import SwiftUI

struct RootSwiftUIModuleBuilder {
    func build() -> UIViewController {
        let store = Store<AppState, RootFeature.Action>(
            reducer: RootFeature.getReducer(),
            state: .init(),
            initialAction: .initial
        )

        return UIHostingController(rootView: RootView(store: store))
    }
}
