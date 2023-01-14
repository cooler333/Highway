//
//  MailFlowCoordinator.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 03.07.2022.
//

import Details
import Domain
import Foundation
import List
import Swinject
import UIKit

final class MailFlowCoordinator: FlowCoordinatorProtocol {
    private weak var window: UIWindow!
    private weak var rootViewController: UIViewController!
    private let resolver: Resolver
    private var childFlowCoordinators: [FlowCoordinatorProtocol] = []

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

        let rootViewController = RootModuleBuilder(
            resolver: resolver,
            moduleOutput: self
        ).build()

        let listFlowCoordinator = ListFlowCoordinator(
            parentViewController: rootViewController,
            resolver: resolver
        )
        childFlowCoordinators.append(listFlowCoordinator)
        listFlowCoordinator.start()

        let detailsFlowCoordinator = DetailsFlowCoordinator(
            parentViewController: rootViewController,
            resolver: resolver
        )
        childFlowCoordinators.append(detailsFlowCoordinator)
        detailsFlowCoordinator.start()

        self.rootViewController = rootViewController
        window.rootViewController = rootViewController
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

extension MailFlowCoordinator: RootModuleOutput {}
