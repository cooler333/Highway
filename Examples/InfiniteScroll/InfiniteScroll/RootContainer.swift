//
//  RootContainer.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 05.05.2022.
//

import Foundation
import Swinject

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

    private func assembleStatefull(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService()
        }
        .inObjectScope(.weak)

        container.register(ToastNotificationManagerProtocol.self) { _ in
            ToastNotificationManager()
        }
        .inObjectScope(.container)
    }
}
