//
//  InfiniteScrollModuleBuilder.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 23.03.2022.
//

import Combine
import Foundation
import Highway
import Swinject
import UIKit

enum InfiniteScrollFeature {}

final class InfiniteScrollModuleBuilder {
    private let resolver: Resolver
    private weak var moduleOutput: InfiniteScrollModuleOutput!

    init(
        resolver: Resolver,
        moduleOutput: InfiniteScrollModuleOutput
    ) {
        self.resolver = resolver
        self.moduleOutput = moduleOutput
    }

    func build() -> UIViewController {
        let environment = InfiniteScrollEnvironment(
            infiniteScrollRepository: resolver.resolve(InfiniteScrollRepositoryProtocol.self)!,
            moduleOutput: moduleOutput
        )
        let store = Store<InfiniteScrollState, InfiniteScrollAction>(
            reducer: InfiniteScrollFeature.getReducer(),
            state: InfiniteScrollState(),
            initialAction: .initial,
            middleware: InfiniteScrollFeature.getMiddlewares(environment: environment)
        )

        let viewController = InfiniteScrollViewController(
            store: store,
            toastNotificationManager: resolver.resolve(ToastNotificationManagerProtocol.self)!
        )
        return viewController
    }
}
