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

        // Act

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
                    []
                ))
            }.eraseToAnyPublisher()
        }

        store.dispatch(.fetchInitialPageInList)

        // Assert

        wait(for: [waitExpectation], timeout: 1)

        let expectedState: MailState.List = .init(
            currentPage: 0,
            isListEnded: true,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )
        XCTAssertEqual(store.state, expectedState)
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

        // Act

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

        store.dispatch(.fetchInitialPageInList)

        // Assert

        wait(for: [waitExpectation], timeout: 1)

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
        XCTAssertEqual(store.state, expectedState)
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

        // Act

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

        store.dispatch(.fetchInitialPageInList)

        // Assert

        wait(for: [waitExpectation], timeout: 10)

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
        XCTAssertEqual(store.state, expectedState)
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

        // Act

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

        store.dispatch(.fetchInitialPageInList)

        wait(for: [firstPageExpectation], timeout: 1)

        wait(forPrecondition: {
            environment.cancellable.isEmpty
        }, completion: { success in
            if success {
                store.dispatch(.fetchNextPageInList)
            } else {
                XCTFail("Expectation is unfillfulled")
            }
        })

        // Assert

        wait(for: [finishExpectation], timeout: 1)

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
        XCTAssertEqual(store.state, expectedState)
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

        // Act

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

        store.dispatch(.fetchInitialPageInList)

        wait(for: [firstPageExpectation], timeout: 10)


        wait(forPrecondition: {
            environment.cancellable.isEmpty
        }, completion: { success in
            if success {
                store.dispatch(.fetchNextPageInList)
            } else {
                XCTFail("Expectation is unfillfulled")
            }
        })

        // Assert

        wait(for: [finishExpectation], timeout: 10)

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
        XCTAssertEqual(states, expectedStates)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 2)
    }

    func testRefresh() throws {
        // FIXME: Impl
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

    private func wait(forPrecondition precondition: @escaping () -> Bool, completion: @escaping (Bool) -> Void) {
        wait(forPrecondition: precondition, iteration: 0, maxIterations: 100, completion: completion)
    }

    private func wait(
        forPrecondition precondition: @escaping () -> Bool,
        iteration: Int,
        maxIterations: Int,
        completion: @escaping (Bool) -> Void
    ) {
        let result = precondition()
        if result == true {
            completion(true)
            return
        }

        if iteration + 1 == maxIterations {
            completion(false)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.wait(forPrecondition: precondition, iteration: iteration + 1, maxIterations: maxIterations, completion: completion)
        })
    }
}

