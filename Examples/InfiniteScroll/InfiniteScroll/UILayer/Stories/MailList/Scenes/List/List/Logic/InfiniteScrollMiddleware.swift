//
//  InfiniteScrollMiddleware.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 29.06.2022.
//

import Combine
import Foundation
import Highway

extension InfiniteScrollFeature {
    static func getMiddlewares(
        environment: InfiniteScrollEnvironment
    ) -> [Middleware<MailListState.List, InfiniteScrollAction>] {
        return [
            getPageLoadingMiddleware(environment: environment),
            getRouteMiddleware(environment: environment),
            getLoggerMiddleware(environment: environment),
        ]
    }
}

extension InfiniteScrollFeature {
    static func getPageLoadingMiddleware(
        environment: InfiniteScrollEnvironment
    ) -> Middleware<MailListState.List, InfiniteScrollAction> {
        var cancellable = Set<AnyCancellable>()

        return createMiddleware(
            environment: environment,
            { dispatch, getState, action, environment in
                guard action == .fetchInitialPageInList || action == .fetchNextPageInList else { return }

                cancellable.forEach { $0.cancel() }

                let state = getState()

                let currentPage: Int
                if action == .fetchInitialPageInList {
                    currentPage = state.currentPage // or just 0
                } else if action == .fetchNextPageInList {
                    currentPage = state.currentPage + 1
                } else {
                    fatalError("unexpected state")
                }

                environment.infiniteScrollRepository.getInfiniteScrolls(
                    with: currentPage,
                    pageLength: state.pageLength,
                    searchText: state.searchText
                )
                .subscribe(on: environment.backgroundQueue)
                .map { result -> InfiniteScrollAction in
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
                .catch { (error: InfiniteScrollAPIError) -> AnyPublisher<InfiniteScrollAction, Never> in
                    if action == .fetchInitialPageInList {
                        return Just<InfiniteScrollAction>(.updateInitialPageInList(data: .failure(error))).eraseToAnyPublisher()
                    } else if action == .fetchNextPageInList {
                        return Just<InfiniteScrollAction>(.addNextPageInList(data: .failure(error))).eraseToAnyPublisher()
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

extension InfiniteScrollFeature {
    static func getRouteMiddleware(
        environment: InfiniteScrollEnvironment
    ) -> Middleware<MailListState.List, InfiniteScrollAction> {
        createMiddleware(
            environment: environment,
            { dispatch, getState, action, environment in
                guard case let .selectInfiniteScrollAtIndex(index) = action else { return }

                // TODO: Check Combine: works like magic without store(&cancellable), but shouldn't`
                let item = getState().data[index]
                _ = Future<InfiniteScrollAction, Never> { promise in
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


extension InfiniteScrollFeature {
    static func getLoggerMiddleware(
        environment: InfiniteScrollEnvironment
    ) -> Middleware<MailListState.List, InfiniteScrollAction> {
        createMiddleware(
            environment: environment,
            { dispatch, getState, action, environment in
                let state = getState()
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

                case .initial,
                     .selectInfiniteScrollAtIndex,
                     .receiveCancelAllRequests,
                     .screenDidOpen:
                    print(Date(), "[\(action)]")
                }
            }
        )
    }
}
