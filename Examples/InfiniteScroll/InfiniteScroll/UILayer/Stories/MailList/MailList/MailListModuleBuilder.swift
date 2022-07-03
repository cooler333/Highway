//
//  MailListModuleBuilder.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 03.07.2022.
//

import Foundation
import Swinject
import UIKit

final class MailListModuleBuilder {
    private let resolver: Resolver
    private weak var moduleOutput: MailListModuleOutput!

    init(
        resolver: Resolver,
        moduleOutput: MailListModuleOutput
    ) {
        self.resolver = resolver
        self.moduleOutput = moduleOutput
    }

    func build() -> UISplitViewController {
        return UISplitViewController()
    }
}
