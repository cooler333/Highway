//
//  IntegrationListTests.swift
//  InfiniteScrollTests
//
//  Created by Dmitrii Cooler on 05.08.2022.
//

import Combine
import Highway
import XCTest

@testable import InfiniteScroll

class IntegrationListTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoData() throws {
        // Arrange

        let listRepository = ListRepositoryProtocolMock()
        let listModuleOutput = ListModuleOutputMock()

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )

        let environment: ListEnvironment = .init(
            listRepository: listRepository,
            moduleOutput: listModuleOutput
        )
        var actionHandler: ((MailState.List, ListAction) -> Void)!

        let store = configure(
            state: state,
            middleware: ListFeature.getPageLoadingMiddleware(environment: environment),
            actionHandler: { state, action in
                actionHandler(state, action)
            }
        )

        let waitExpectation = expectation(description: "wait")

        actionHandler = { state, action in
            switch action {
            case .updateInitialPageInList:
                waitExpectation.fulfill()

            case .fetchInitialPageInList:
                break

            default:
                XCTFail("unexpected action")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                promise(.success([]))
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.fetchInitialPageInList)
        wait(for: [waitExpectation], timeout: 1)

        // Assert

        let expectedState: MailState.List = .init(
            currentPage: 0,
            isListEnded: true,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )
        XCTAssertEqualWithDiff(store.state, expectedState)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 1)
    }

    func testNoDataError() throws {
        // Arrange

        let listRepository = ListRepositoryProtocolMock()
        let listModuleOutput = ListModuleOutputMock()

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )

        let environment: ListEnvironment = .init(
            listRepository: listRepository,
            moduleOutput: listModuleOutput
        )
        var actionHandler: ((MailState.List, ListAction) -> Void)!

        let store = configure(
            state: state,
            middleware: ListFeature.getPageLoadingMiddleware(environment: environment),
            actionHandler: { state, action in
                actionHandler(state, action)
            }
        )

        let waitExpectation = expectation(description: "wait")

        actionHandler = { state, action in
            switch action {
            case .updateInitialPageInList:
                waitExpectation.fulfill()

            case .fetchInitialPageInList:
                break

            default:
                XCTFail("unexpected action")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                promise(.failure(URLError.init(.timedOut)))
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.fetchInitialPageInList)
        wait(for: [waitExpectation], timeout: 1)

        // Assert

        let expectedState: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .error(.networkError),
            data: [],
            searchText: nil,
            selectedMailID: nil
        )
        XCTAssertEqualWithDiff(store.state, expectedState)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 1)
    }

    func testFetchInitialPageLessThanPageLength() throws {
        // Arrange

        let listRepository = ListRepositoryProtocolMock()
        let listModuleOutput = ListModuleOutputMock()

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )

        let environment: ListEnvironment = .init(
            listRepository: listRepository,
            moduleOutput: listModuleOutput
        )
        var actionHandler: ((MailState.List, ListAction) -> Void)!

        let store = configure(
            state: state,
            middleware: ListFeature.getPageLoadingMiddleware(environment: environment),
            actionHandler: { state, action in
                actionHandler(state, action)
            }
        )

        let waitExpectation = expectation(description: "wait")

        actionHandler = { state, action in
            switch action {
            case .updateInitialPageInList:
                waitExpectation.fulfill()

            case .fetchInitialPageInList:
                break

            default:
                XCTFail("unexpected action")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                promise(.success(
                    (0..<pageLength - 1).map { index in
                        .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                    }
                ))
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.fetchInitialPageInList)
        wait(for: [waitExpectation], timeout: 1)

        // Assert

        let expectedState: MailState.List = .init(
            currentPage: 0,
            isListEnded: true,
            loadingState: .idle,
            data: (0..<environment.pageLength - 1).map { index in
                .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
            },
            searchText: nil,
            selectedMailID: nil
        )
        XCTAssertEqualWithDiff(store.state, expectedState)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 1)
    }

    func testFetchInitialPageMoreThanPageLength() throws {
        // Arrange

        let listRepository = ListRepositoryProtocolMock()
        let listModuleOutput = ListModuleOutputMock()

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )

        let environment: ListEnvironment = .init(
            listRepository: listRepository,
            moduleOutput: listModuleOutput
        )
        var actionHandler: ((MailState.List, ListAction) -> Void)!

        let store = configure(
            state: state,
            middleware: ListFeature.getPageLoadingMiddleware(environment: environment),
            actionHandler: { state, action in
                actionHandler(state, action)
            }
        )

        let waitExpectation = expectation(description: "wait")

        actionHandler = { state, action in
            switch action {
            case .updateInitialPageInList:
                waitExpectation.fulfill()

            case .fetchInitialPageInList:
                break

            default:
                XCTFail("unexpected action")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                promise(.success(
                    (0..<pageLength).map { index in
                        .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                    }
                ))
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.fetchInitialPageInList)
        wait(for: [waitExpectation], timeout: 1)

        // Assert

        let expectedState: MailState.List = .init(
            currentPage: 1,
            isListEnded: false,
            loadingState: .idle,
            data: (0..<environment.pageLength).map { index in
                .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
            },
            searchText: nil,
            selectedMailID: nil
        )
        XCTAssertEqualWithDiff(store.state, expectedState)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 1)
    }

    func testFetchNextLastPage() throws {
        // Arrange

        let listRepository = ListRepositoryProtocolMock()
        let listModuleOutput = ListModuleOutputMock()

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )

        let environment: ListEnvironment = .init(
            listRepository: listRepository,
            moduleOutput: listModuleOutput
        )
        var actionHandler: ((MailState.List, ListAction) -> Void)!

        let store = configure(
            state: state,
            middleware: ListFeature.getPageLoadingMiddleware(environment: environment),
            actionHandler: { state, action in
                actionHandler(state, action)
            }
        )

        let firstPageExpectation = expectation(description: "finishPage")
        let finishExpectation = expectation(description: "finish")

        actionHandler = { state, action in
            switch action {
            case .updateInitialPageInList:
                firstPageExpectation.fulfill()

            case .addNextPageInList:
                finishExpectation.fulfill()

            case .fetchInitialPageInList,
                 .fetchNextPageInList:
                break

            default:
                XCTFail("unexpected action: \(action)")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                let startIndex = currentPage * pageLength

                let count: Int
                if currentPage == 0 {
                    count = pageLength
                } else {
                    count = pageLength - 1
                }

                let data: [ListModel] = (startIndex..<startIndex + count).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                }
                promise(.success(data))
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.fetchInitialPageInList)
        wait(for: [firstPageExpectation], timeout: 1)

        wait(forPrecondition: {
            environment.cancellable.isEmpty
        }, completion: {
            store.dispatch(.fetchNextPageInList)
        })
        wait(for: [finishExpectation], timeout: 1)

        // Assert

        let expectedState: MailState.List = .init(
            currentPage: 1,
            isListEnded: true,
            loadingState: .idle,
            data: (0..<environment.pageLength * 2 - 1).map { index in
                .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
            },
            searchText: nil,
            selectedMailID: nil
        )
        XCTAssertEqualWithDiff(store.state, expectedState)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 2)
    }

    func testNextPageError() throws {
        // Arrange

        let listRepository = ListRepositoryProtocolMock()
        let listModuleOutput = ListModuleOutputMock()

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )

        let environment: ListEnvironment = .init(
            listRepository: listRepository,
            moduleOutput: listModuleOutput
        )
        var actionHandler: ((MailState.List, ListAction) -> Void)!

        let store = configure(
            state: state,
            middleware: ListFeature.getPageLoadingMiddleware(environment: environment),
            actionHandler: { state, action in
                actionHandler(state, action)
            }
        )

        let firstPageExpectation = expectation(description: "finishPage")
        let finishExpectation = expectation(description: "finish")

        actionHandler = { state, action in
            switch action {
            case .updateInitialPageInList:
                firstPageExpectation.fulfill()

            case .addNextPageInList:
                finishExpectation.fulfill()

            case .fetchInitialPageInList,
                 .fetchNextPageInList:
                break

            default:
                XCTFail("unexpected action: \(action)")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                let startIndex = currentPage * pageLength
                let count = pageLength

                if currentPage == 0 {
                    let data: [ListModel] = (startIndex..<startIndex + count).map { index in
                        .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                    }
                    promise(.success(data))
                } else {
                    promise(.failure(URLError.init(.timedOut)))
                }
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.fetchInitialPageInList)
        wait(for: [firstPageExpectation], timeout: 1)

        wait(forPrecondition: {
            environment.cancellable.isEmpty
        }, completion: {
            store.dispatch(.fetchNextPageInList)
        })
        wait(for: [finishExpectation], timeout: 1)

        // Assert

        let expectedState: MailState.List = .init(
            currentPage: 1,
            isListEnded: false,
            loadingState: .error(.networkError),
            data: (0..<environment.pageLength * 1).map { index in
                .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
            },
            searchText: nil,
            selectedMailID: nil
        )
        XCTAssertEqualWithDiff(store.state, expectedState)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 2)
    }

    func testFetchNextNotLastPage() throws {
        // Arrange

        let listRepository = ListRepositoryProtocolMock()
        let listModuleOutput = ListModuleOutputMock()

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )

        let environment: ListEnvironment = .init(
            listRepository: listRepository,
            moduleOutput: listModuleOutput
        )
        var actionHandler: ((MailState.List, ListAction) -> Void)!

        let store = configure(
            state: state,
            middleware: ListFeature.getPageLoadingMiddleware(environment: environment),
            actionHandler: { state, action in
                actionHandler(state, action)
            }
        )
        var states: [MailState.List] = []
        states.append(store.state)
        store.subscribe { state in
            states.append(state)
        }

        let firstPageExpectation = expectation(description: "finishPage")
        let finishExpectation = expectation(description: "finish")

        actionHandler = { state, action in
            switch action {
            case .updateInitialPageInList:
                firstPageExpectation.fulfill()

            case .addNextPageInList:
                finishExpectation.fulfill()

            case .fetchInitialPageInList,
                 .fetchNextPageInList:
                break

            default:
                XCTFail("unexpected action: \(action)")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                let startIndex = currentPage * pageLength
                let count = pageLength

                let data: [ListModel] = (startIndex..<startIndex + count).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                }
                promise(.success(data))
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.fetchInitialPageInList)
        wait(for: [firstPageExpectation], timeout: 1)

        wait(forPrecondition: {
            environment.cancellable.isEmpty
        }, completion: {
            store.dispatch(.fetchNextPageInList)
        })
        wait(for: [finishExpectation], timeout: 1)

        // Assert

        let expectedStates: [MailState.List] = [
            .init(currentPage: 0, isListEnded: false, loadingState: .idle, data: [], searchText: nil, selectedMailID: nil),
            .init(currentPage: 0, isListEnded: false, loadingState: .refresh, data: [], searchText: nil, selectedMailID: nil),
            .init(
                currentPage: 1,
                isListEnded: false,
                loadingState: .idle,
                data: (0..<environment.pageLength).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                },
                searchText: nil, selectedMailID: nil
            ),
            .init(
                currentPage: 1,
                isListEnded: false,
                loadingState: .nextPage,
                data: (0..<environment.pageLength).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                },
                searchText: nil,
                selectedMailID: nil
            ),
            .init(
                currentPage: 2,
                isListEnded: false,
                loadingState: .idle,
                data: (0..<environment.pageLength * 2).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                },
                searchText: nil,
                selectedMailID: nil

            )
        ]
        XCTAssertEqualWithDiff(states, expectedStates)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 2)
    }

    func testNextPageErrorAndSuccessRefresh() throws {
        // Arrange

        let listRepository = ListRepositoryProtocolMock()
        let listModuleOutput = ListModuleOutputMock()

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )

        let environment: ListEnvironment = .init(
            listRepository: listRepository,
            moduleOutput: listModuleOutput
        )
        var actionHandler: ((MailState.List, ListAction) -> Void)!

        let store = configure(
            state: state,
            middleware: ListFeature.getPageLoadingMiddleware(environment: environment),
            actionHandler: { state, action in
                actionHandler(state, action)
            }
        )
        var states: [MailState.List] = []
        states.append(store.state)
        store.subscribe { state in
            states.append(state)
        }

        let firstPageExpectation = expectation(description: "finishPage")
        let errorExpectation = expectation(description: "error")
        let finishExpectation = expectation(description: "finish")

        actionHandler = { state, action in
            switch action {
            case .updateInitialPageInList:
                firstPageExpectation.fulfill()

            case let .addNextPageInList(result):
                switch result {
                case .failure:
                    errorExpectation.fulfill()

                case .success:
                    finishExpectation.fulfill()
                }

            case .fetchInitialPageInList,
                 .fetchNextPageInList:
                break

            default:
                XCTFail("unexpected action: \(action)")
            }
        }

        var isError = false

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                let startIndex = currentPage * pageLength
                let count = pageLength

                if currentPage == 0 {
                    let data: [ListModel] = (startIndex..<startIndex + count).map { index in
                        .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                    }
                    promise(.success(data))
                } else {
                    if isError {
                        promise(.failure(URLError.init(.timedOut)))
                    } else {
                        let data: [ListModel] = (startIndex..<startIndex + count).map { index in
                            .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                        }
                        promise(.success(data))
                    }
                }
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.fetchInitialPageInList)
        wait(for: [firstPageExpectation], timeout: 1)

        isError = true

        wait(forPrecondition: {
            environment.cancellable.isEmpty
        }, completion: {
            store.dispatch(.fetchNextPageInList)
        })
        wait(for: [errorExpectation], timeout: 1)

        isError = false

        wait(forPrecondition: {
            environment.cancellable.isEmpty
        }, completion: {
            store.dispatch(.fetchNextPageInList)
        })

        wait(for: [finishExpectation], timeout: 10)

        // Assert

        let expectedStates: [MailState.List] = [
            .init(currentPage: 0, isListEnded: false, loadingState: .idle, data: [], searchText: nil, selectedMailID: nil),
            .init(currentPage: 0, isListEnded: false, loadingState: .refresh, data: [], searchText: nil, selectedMailID: nil),
            .init(
                currentPage: 1,
                isListEnded: false,
                loadingState: .idle,
                data: (0..<environment.pageLength).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                },
                searchText: nil, selectedMailID: nil
            ),
            .init(
                currentPage: 1,
                isListEnded: false,
                loadingState: .nextPage,
                data: (0..<environment.pageLength).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                },
                searchText: nil,
                selectedMailID: nil
            ),
            .init(
                currentPage: 1,
                isListEnded: false,
                loadingState: .error(.networkError),
                data: (0..<environment.pageLength).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                },
                searchText: nil,
                selectedMailID: nil
            ),
            .init(
                currentPage: 1,
                isListEnded: false,
                loadingState: .nextPage,
                data: (0..<environment.pageLength).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                },
                searchText: nil,
                selectedMailID: nil
            ),
            .init(
                currentPage: 2,
                isListEnded: false,
                loadingState: .idle,
                data: (0..<environment.pageLength * 2).map { index in
                    .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                },
                searchText: nil,
                selectedMailID: nil
            )
        ]
        XCTAssertEqualWithDiff(states, expectedStates)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 3)
    }

    func testSearch() throws {
        XCTFail("Impl")
    }
}

extension IntegrationListTests {
    private func configure(
        state: MailState.List,
        middleware: @escaping Middleware<MailState.List, ListAction>,
        actionHandler: @escaping (MailState.List, ListAction) -> Void
    ) -> Store<MailState.List, ListAction> {
        let testMiddleware: Middleware<MailState.List, ListAction> = createMiddleware { dispatch, getState, action in
            guard let state = getState() else { return }
            actionHandler(state, action)
        }

        let store = Store<MailState.List, ListAction>(
            reducer: ListFeature.getReducer(),
            state: state,
            middleware: [middleware, testMiddleware]
        )

        return store
    }
}
