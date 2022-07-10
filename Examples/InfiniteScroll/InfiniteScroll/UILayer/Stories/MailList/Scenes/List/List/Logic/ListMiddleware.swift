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
    ) -> [Middleware<MailListState.List, ListAction>] {
        return [
            getPageLoadingMiddleware(environment: environment),
            getRouteMiddleware(environment: environment),
            getLoggerMiddleware(environment: environment),
        ]
    }
}

extension ListFeature {
    static func getPageLoadingMiddleware(
        environment: ListEnvironment
    ) -> Middleware<MailListState.List, ListAction> {
        var cancellable = Set<AnyCancellable>()

        return createMiddleware(
            environment: environment,
            { dispatch, state, action, environment in
                guard action == .fetchInitialPageInList || action == .fetchNextPageInList else { return }

                cancellable.forEach { $0.cancel() }

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
                }.store(in: &cancellable)
            }
        )
    }
}

extension ListFeature {
    static func getRouteMiddleware(
        environment: ListEnvironment
    ) -> Middleware<MailListState.List, ListAction> {
        createMiddleware(
            environment: environment,
            { dispatch, state, action, environment in
                guard case let .selectListAtIndex(index) = action else { return }

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

class Check {
    let foo: String
    init(foo: String) {
        self.foo = foo
        print("INIT: \(foo)")
    }
    
    deinit {
        print("DEINIT: \(foo)")
    }
}


extension ListFeature {
    static func getLoggerMiddleware(
        environment: ListEnvironment
    ) -> Middleware<MailListState.List, ListAction> {
        createMiddleware(
            environment: environment,
            { dispatch, state, action, environment in
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
                        print(Date(), "[updateInitialPageInList] count: \(data.count), searchText: \(state.searchText ?? "nil")")

                    case let .failure(error):
                        print(Date(), "[updateInitialPageInList] error: \(error.localizedDescription), searchText: \(state.searchText ?? "nil")")
                    }

                case .fetchInitialPageInList:
                    print(Date(), "[fetchInitialPageInList] page: \(state.currentPage), searchText: \(state.searchText ?? "nil")")

                case .fetchNextPageInList:
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
