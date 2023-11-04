//
//  IntegrationListTests.swift
//  InfiniteScrollTests
//
//  Created by Dmitrii Cooler on 05.08.2022.
//

import Combine
import Highway
import XCTest

@testable import Domain
@testable import InfiniteScroll
@testable import List

// swiftlint:disable:next type_body_length
class IntegrationListTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
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
                XCTFail("unexpected action: \(action)")
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
                XCTFail("unexpected action: \(action)")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                promise(.failure(URLError(.timedOut)))
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

    // swiftlint:disable:next function_body_length
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
                XCTFail("unexpected action: \(action)")
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

    // swiftlint:disable:next function_body_length
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
                XCTFail("unexpected action: \(action)")
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

    // swiftlint:disable:next function_body_length
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

    // swiftlint:disable:next function_body_length
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
                    promise(.failure(URLError(.timedOut)))
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

    // swiftlint:disable:next function_body_length
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
            .init(
                currentPage: 0,
                isListEnded: false,
                loadingState: .idle,
                data: [],
                searchText: nil,
                selectedMailID: nil
            ),
            .init(
                currentPage: 0,
                isListEnded: false,
                loadingState: .refresh,
                data: [],
                searchText: nil,
                selectedMailID: nil
            ),
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
            ),
        ]
        XCTAssertEqualWithDiff(states, expectedStates)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 2)
    }

    // swiftlint:disable:next function_body_length
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
                        promise(.failure(URLError(.timedOut)))
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
            .init(
                currentPage: 0,
                isListEnded: false,
                loadingState: .idle,
                data: [],
                searchText: nil,
                selectedMailID: nil
            ),
            .init(
                currentPage: 0,
                isListEnded: false,
                loadingState: .refresh,
                data: [],
                searchText: nil,
                selectedMailID: nil
            ),
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
            ),
        ]
        XCTAssertEqualWithDiff(states, expectedStates)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 3)
    }

    // swiftlint:disable:next function_body_length
    func testSearch() throws {
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

            case .fetchInitialPageInList,
                 .search:
                break

            default:
                XCTFail("unexpected action: \(action)")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Future<[ListModel], Error> { promise in
                promise(.success(
                    (0..<pageLength - 1).map { index in
                        let details = searchText ?? "unknown"
                        return .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: details)
                    }
                ))
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.search(searchText: "foobar"))
        store.dispatch(.fetchInitialPageInList)
        wait(for: [waitExpectation], timeout: 1)

        // Assert

        let expectedState: MailState.List = .init(
            currentPage: 0,
            isListEnded: true,
            loadingState: .idle,
            data: (0..<environment.pageLength - 1).map { index in
                .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "foobar")
            },
            searchText: "foobar",
            selectedMailID: nil
        )
        XCTAssertEqualWithDiff(store.state, expectedState)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 1)
    }

    // swiftlint:disable:next function_body_length
    func testMultipleFetchPage() throws {
        // TODO: Fix race condition with AnyCancellable.cancel() and Future
        // swiftlint:disable:next line_length
        XCTFail("Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'API violation - multiple calls made to -[XCTestExpectation fulfill] for updateInitialPageInList.'")

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

        let getPageDidCancelExpectation = expectation(description: "getPageDidCancel")
        let updateInitialPageInListExpectation = expectation(description: "updateInitialPageInList")

        actionHandler = { state, action in
            switch action {
            case .getPageDidCancel:
                getPageDidCancelExpectation.fulfill()

            case .updateInitialPageInList:
                updateInitialPageInListExpectation.fulfill()

            case .fetchInitialPageInList:
                break

            default:
                XCTFail("unexpected action: \(action)")
            }
        }

        listRepository.getListsWithPageLengthSearchTextClosure = { currentPage, pageLength, searchText in
            Deferred {
                Future<[ListModel], Error>({ promise in
                    DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.5) {
                        promise(.success(
                            (0..<pageLength - 1).map { index in
                                .init(title: "Foo\(index)", subtitle: "Bar", id: "foobar\(index)", details: "barfoo")
                            }
                        ))
                    }
                }).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
        }

        // Act

        store.dispatch(.fetchInitialPageInList)
        store.dispatch(.fetchInitialPageInList)
        wait(for: [getPageDidCancelExpectation, updateInitialPageInListExpectation], timeout: 20)

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
        XCTAssertEqualWithDiff(expectedState, store.state)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 2)
    }
}

extension IntegrationListTests {
    private func configure(
        state: MailState.List,
        middleware: Middleware<MailState.List, ListAction>,
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
    // swiftlint:disable:next file_length
}
