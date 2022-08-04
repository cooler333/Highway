//
//  RootModuleBuilder.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 03.07.2022.
//

import Foundation
import Swinject
import UIKit

final class RootModuleBuilder {
    private let resolver: Resolver
    private weak var moduleOutput: RootModuleOutput!

    init(
        resolver: Resolver,
        moduleOutput: RootModuleOutput
    ) {
        self.resolver = resolver
        self.moduleOutput = moduleOutput
    }

    func build() -> UISplitViewController {
        return UISplitViewController()
    }
}
