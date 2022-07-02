//
//  InfiniteScrollFlowCoordinator.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 01.02.2022.
//

import Foundation
import Swinject
import UIKit

final class InfiniteScrollFlowCoordinator: FlowCoordinatorProtocol {
    private weak var window: UIWindow!
    private weak var rootViewController: UINavigationController!
    private let resolver: Resolver
    private var childFlowCoordinator: FlowCoordinatorProtocol?

    private(set) var state: FlowCoordinatorState = .created

    init(
        window: UIWindow,
        resolver: Resolver
    ) {
        self.window = window
        self.resolver = resolver
    }

    func start() {
        guard state == .created else {
            return
        }
        state = .started

        let viewController = InfiniteScrollModuleBuilder(
            resolver: resolver,
            moduleOutput: self
        ).build()
        viewController.title = "InfiniteScroll"

        let nvc = UINavigationController(rootViewController: viewController)
        rootViewController = nvc

        let tabBarItem = UITabBarItem(
            title: "InfiniteScroll",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        nvc.tabBarItem = tabBarItem

        rootViewController = nvc
        window.rootViewController = nvc
    }

    func handleDeeplink(with _: URL) {
        // unused
    }

    func finish(compltion: @escaping () -> Void) {
        guard state == .started else {
            compltion()
            return
        }
        state = .finished

        compltion()
    }
}

extension InfiniteScrollFlowCoordinator: InfiniteScrollModuleOutput {
    func infiniteScrollModuleWantsToOpenDetails(with id: String) {
        resolver.resolve(ToastNotificationManagerProtocol.self)!.showNotification(
            with: .info(
                title: "Details did open",
                message: id
            )
        )
    }
}
