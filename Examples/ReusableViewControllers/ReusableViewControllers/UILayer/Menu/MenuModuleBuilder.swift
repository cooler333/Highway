//
//  MenuModuleBuilder.swift
//  ReusableViewControllers
//
//  Created by Dmitrii Cooler on 31.07.2022.
//

import Highway
import UIKit

struct MenuModuleBuilder {
    func build() -> UIViewController {
        let tabBarController = UITabBarController()

        let imperativeRootVC = ImperativeRootModuleBuilder().build()
        imperativeRootVC.tabBarItem = .init(title: "Imperative", image: nil, selectedImage: nil)

        let viewStoreVC = ViewStoreRootModuleBuilder().build()
        viewStoreVC.tabBarItem = .init(title: "ViewStore", image: nil, selectedImage: nil)

        tabBarController.viewControllers = [
            imperativeRootVC,
            viewStoreVC,
        ]

        return tabBarController
    }
}
