//
//  ListModuleBuilder.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 23.03.2022.
//

import Combine
import Foundation
import Highway
import Swinject
import UIKit

enum ListFeature {}

final class ListModuleBuilder {
    private let resolver: Resolver
    private weak var moduleOutput: ListModuleOutput!

    init(
        resolver: Resolver,
        moduleOutput: ListModuleOutput
    ) {
        self.resolver = resolver
        self.moduleOutput = moduleOutput
    }

    func build() -> UIViewController {
        let environment = ListEnvironment(
            listRepository: resolver.resolve(ListRepositoryProtocol.self)!,
            moduleOutput: moduleOutput
        )
        let store = Store<MailListState.List, ListAction>(
            reducer: ListFeature.getReducer(),
            state: MailListState.List(),
            initialAction: .initial,
            middleware: ListFeature.getMiddlewares(environment: environment)
        )

        let viewController = ListViewController(
            store: store,
            toastNotificationManager: resolver.resolve(ToastNotificationManagerProtocol.self)!
        )
        return viewController
    }
}
