//
//  DetailsFlowCoordinator.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 03.07.2022.
//

import Domain
import Foundation
import Swinject
import UIKit

public final class DetailsFlowCoordinator: FlowCoordinatorProtocol {
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
            name: "Details"
        )!
        viewController.title = "Details" // FIXME: Show ID

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

extension DetailsFlowCoordinator: DetailsModuleOutput {}
