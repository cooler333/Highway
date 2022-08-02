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

        let uikitRootVC = RootUIKitModuleBuilder().build()
        uikitRootVC.tabBarItem = .init(title: "UIKit", image: nil, selectedImage: nil)

        let swiftuiRootVC = RootSwiftUIModuleBuilder().build()
        swiftuiRootVC.tabBarItem = .init(title: "SwiftUI", image: nil, selectedImage: nil)

        tabBarController.viewControllers = [
            uikitRootVC,
            swiftuiRootVC,
        ]

        return tabBarController
    }
}
