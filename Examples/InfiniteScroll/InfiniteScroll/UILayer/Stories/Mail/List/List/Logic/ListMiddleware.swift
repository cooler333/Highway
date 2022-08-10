//
//  ListMiddleware.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 29.06.2022.
//

import Combine
import Foundation
import Highway

extension ListFeature {
    static func getMiddlewares(
        environment: ListEnvironment
    ) -> [Middleware<MailState.List, ListAction>] {
        return [
            getPageLoadingMiddleware(environment: environment),
            getRouteMiddleware(environment: environment),
            getLoggerMiddleware(environment: environment),
        ]
    }
}

extension ListFeature {
    // swiftlint:disable:next function_body_length
    static func getPageLoadingMiddleware(
        environment: ListEnvironment
    ) -> Middleware<MailState.List, ListAction> {
        return createMiddleware(
            environment: environment,
            { dispatch, getState, action, environment in
                guard action == .fetchInitialPageInList || action == .fetchNextPageInList else { return }

                environment.cancellable.forEach { $0.cancel() }
                guard let state = getState() else { return }
                let currentPage: Int
                if action == .fetchInitialPageInList {
                    currentPage = state.currentPage // or just 0
                } else if action == .fetchNextPageInList {
                    currentPage = state.currentPage + 1
                } else {
                    fatalError("unexpected state")
                }

                environment.listRepository.getLists(
                    with: currentPage,
                    pageLength: state.pageLength,
                    searchText: state.searchText
                )
                .subscribe(on: environment.backgroundQueue)
                .map { result -> ListAction in
                    if action == .fetchInitialPageInList {
                        return .updateInitialPageInList(data: .success(result))
                    } else if action == .fetchNextPageInList {
                        return .addNextPageInList(data: .success(result))
                    } else {
                        fatalError("unexpected state")
                    }
                }
                .mapError { _ in
                    .networkError
                }
                .catch { (error: ListAPIError) -> AnyPublisher<ListAction, Never> in
                    if action == .fetchInitialPageInList {
                        return Just<ListAction>(.updateInitialPageInList(data: .failure(error))).eraseToAnyPublisher()
                    } else if action == .fetchNextPageInList {
                        return Just<ListAction>(.addNextPageInList(data: .failure(error))).eraseToAnyPublisher()
                    } else {
                        fatalError("unexpected state")
                    }
                }
                .eraseToAnyPublisher()
                .receive(on: environment.mainQueue)
                .handleEvents(receiveCancel: {
                    dispatch(.getPageDidCancel(searchText: state.searchText))
                })
                .sink { action in
                    dispatch(action)
                }.store(in: &environment.cancellable)
            }
        )
    }
}

extension ListFeature {
    static func getRouteMiddleware(
        environment: ListEnvironment
    ) -> Middleware<MailState.List, ListAction> {
        createMiddleware(
            environment: environment,
            { dispatch, getState, action, environment in
                guard case let .selectListAtIndex(index) = action else { return }
                guard let state = getState() else { return }

                // TODO: Check Combine: works like magic without store(&cancellable), but shouldn't`
                let item = state.data[index]
                _ = Future<ListAction, Never> { promise in
                    environment.moduleOutput?.listModuleWantsToOpenDetails(
                        with: item.id
                    )
                    promise(.success(.screenDidOpen))
                }
                .subscribe(on: environment.mainQueue)
                .eraseToAnyPublisher()
                .sink(receiveValue: { action in
                    dispatch(action)
                })
            }
        )
    }
}

extension ListFeature {
    // swiftlint:disable:next cyclomatic_complexity
    static func getLoggerMiddleware(
        environment: ListEnvironment
    ) -> Middleware<MailState.List, ListAction> {
        createMiddleware(
            environment: environment,
            { _, getState, action, _ in
                guard let state = getState() else { return }
                switch action {
                case let .addNextPageInList(result):
                    switch result {
                    case let .success(data):
                        print(Date(), "[addNextPageInList] count: \(data.count)")

                    case let .failure(error):
                        print(Date(), "[addNextPageInList] error: \(error.localizedDescription)")
                    }

                case let .updateInitialPageInList(result):
                    switch result {
                    case let .success(data):
                        // swiftlint:disable:next line_length
                        print(Date(), "[updateInitialPageInList] count: \(data.count), searchText: \(state.searchText ?? "nil")")

                    case let .failure(error):
                        // swiftlint:disable:next line_length
                        print(Date(), "[updateInitialPageInList] error: \(error.localizedDescription), searchText: \(state.searchText ?? "nil")")
                    }

                case .fetchInitialPageInList:
                    // swiftlint:disable:next line_length
                    print(Date(), "[fetchInitialPageInList] page: \(state.currentPage), searchText: \(state.searchText ?? "nil")")

                case .fetchNextPageInList:
                    // swiftlint:disable:next line_length
                    print(Date(), "[fetchNextPageInList] page: \(state.currentPage), searchText: \(state.searchText ?? "nil")")

                case let .search(searchText):
                    print(Date(), "[search] text: \(searchText ?? "nil")")

                case let .getPageDidCancel(searchText):
                    print(Date(), "[getPageDidCancel] search text: \(searchText ?? "nil")")

                case .selectListAtIndex:
                    print(Date(), "[selectListAtIndex] selected ID: \(state.selectedMailID ?? "nil")")

                case .initial,
                     .receiveCancelAllRequests,
                     .screenDidOpen:
                    print(Date(), "[\(action)]")
                }
            }
        )
    }
}
