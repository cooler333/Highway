//
//  ListFlowCoordinator.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 01.02.2022.
//

import Domain
import Foundation
import Swinject
import UIKit

protocol ListFlowCoordinatorOutput: AnyObject {
    func listFlowCoordinatorWantsToOpenDetails(with id: String)
}

public final class ListFlowCoordinator: FlowCoordinatorProtocol {
    private weak var parentViewController: UISplitViewController!
    private weak var rootViewController: UINavigationController!
    private let resolver: Resolver
    private var childFlowCoordinator: FlowCoordinatorProtocol?

    public private(set) var state: FlowCoordinatorState = .created

    public init(
        parentViewController: UISplitViewController,
        resolver: Resolver
    ) {
        self.parentViewController = parentViewController
        self.resolver = resolver
    }

    public func start() {
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

    public func handleDeeplink(with _: URL) {
        // unused
    }

    public func finish(compltion: @escaping () -> Void) {
        guard state == .started else {
            compltion()
            return
        }
        state = .finished

        compltion()
    }
}

extension ListFlowCoordinator: ListModuleOutput {
    public func listModuleWantsToOpenDetails(with id: String) {
        resolver.resolve(ToastNotificationManagerProtocol.self)!.showNotification(
            with: .info(
                title: "Details did open",
                message: id
            )
        )
    }
}
