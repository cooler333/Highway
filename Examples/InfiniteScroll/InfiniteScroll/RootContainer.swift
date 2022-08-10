//
//  RootContainer.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 05.05.2022.
//

import Foundation
import Highway
import Swinject
import UIKit

final class RootContainer {
    private let assembler: Assembler

    var resolver: Resolver {
        assembler.resolver
    }

    init() {
        assembler = Assembler([
            RootAssembly(),
        ])
    }
}

public final class RootAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        assembleStateless(container: container)
        assembleStatefull(container: container)
    }

    private func assembleStateless(container: Container) {
        container.register(ListModelParserProtocol.self) { _ in
            ListModelParser()
        }

        container.register(ListRepositoryProtocol.self) { _ in
            ListRepositoryMock()

            // if you want to use real api
            // uncomment next line and change url domain

            // ListRepository(
            //     networkService: resolver.resolve(NetworkServiceProtocol.self)!,
            //     listModelParser: resolver.resolve(ListModelParserProtocol.self)!
            // )
        }
    }

    // swiftlint:disable:next function_body_length
    private func assembleStatefull(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService()
        }
        .inObjectScope(.weak)

        container.register(ToastNotificationManagerProtocol.self) { _ in
            ToastNotificationManager()
        }
        .inObjectScope(.container)

        container.register(Store<MailState, ListAction>.self) { _ in
            let store = Store<MailState, ListAction>(
                reducer: .init { state, _ in
                    state
                },
                state: .init(),
                initialAction: .initial,
                middleware: []
            )
            return store
        }.inObjectScope(.weak)

        container.register(UIViewController.self, name: "Details") { resolver in
            let mailListStore = resolver.resolve(Store<MailState, ListAction>.self)!
            let store = mailListStore.createChildStore(
                keyPath: \.list,
                reducer: Reducer<MailState.List, String> { state, _ in
                    state
                },
                initialAction: "",
                middleware: []
            )
            let viewController = DetailsViewController(
                store: store
            )
            return viewController
        }

        container.register(
            UIViewController.self, name: "List"
        ) { (resolver, moduleOutput: ListModuleOutput) in
            let mailListStore = resolver.resolve(Store<MailState, ListAction>.self)!
            let environment = ListEnvironment(
                listRepository: resolver.resolve(ListRepositoryProtocol.self)!,
                moduleOutput: moduleOutput
            )
            let store = mailListStore.createChildStore(
                keyPath: \.list,
                reducer: ListFeature.getReducer(),
                initialAction: .initial,
                middleware: ListFeature.getMiddlewares(environment: environment)
            )
            let viewStore = ViewStore<MailState.List, ListAction>(
                store: store,
                stateMapper: { state in
                    state
                },
                actionMapper: { action in
                    action
                }
            )
            let viewController = ListViewController(
                store: viewStore,
                toastNotificationManager: resolver.resolve(ToastNotificationManagerProtocol.self)!
            )
            return viewController
        }
    }
}
