//
//  ListFlowCoordinator.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 01.02.2022.
//

import Foundation
import Swinject
import UIKit

protocol ListFlowCoordinatorOutput: AnyObject {
    func listFlowCoordinatorWantsToOpenDetails(with id: String)
}

final class ListFlowCoordinator: FlowCoordinatorProtocol {
    private weak var parentViewController: UISplitViewController!
    private weak var rootViewController: UINavigationController!
    private let resolver: Resolver
    private var childFlowCoordinator: FlowCoordinatorProtocol?

    private(set) var state: FlowCoordinatorState = .created

    init(
        parentViewController: UISplitViewController,
        resolver: Resolver
    ) {
        self.parentViewController = parentViewController
        self.resolver = resolver
    }

    func start() {
        guard state == .created else {
            return
        }
        state = .started

        let viewController = resolver.resolve(
            UIViewController.self,
            name: "List",
            argument: self as ListModuleOutput
        )!
        viewController.title = "List"

        let nvc = UINavigationController(rootViewController: viewController)
        rootViewController = nvc

        rootViewController = nvc
        parentViewController.viewControllers.append(nvc)
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

extension ListFlowCoordinator: ListModuleOutput {
    func listModuleWantsToOpenDetails(with id: String) {
        resolver.resolve(ToastNotificationManagerProtocol.self)!.showNotification(
            with: .info(
                title: "Details did open",
                message: id
            )
        )
    }
}
