//
//  MiddlewareListTests.swift
//  InfiniteScrollTests
//
//  Created by Dmitrii Cooler on 05.08.2022.
//

import Combine
import Highway
import XCTest

@testable import InfiniteScroll

class MiddlewareListTests: XCTestCase {

    private var store: Store<MailState.List, ListAction>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        store = nil
    }

    func testExample() throws {

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

        let expectData: [ListModel] = [
            .init(title: "Foo", subtitle: "Bar", id: "foobar", details: "barfoo")
        ]
        var resultData: [ListModel]!

        let waitExpectation = expectation(description: "wait")

        store = configure(
            state: state,
            middleware: ListFeature.getPageLoadingMiddleware(
                environment: .init(
                    listRepository: listRepository,
                    moduleOutput: listModuleOutput
                )
            ),
            actionHandler: { state, action in
                switch action {
                case let .updateInitialPageInList(result):
                    switch result {
                    case let .success(data):
                        resultData = data

                    case .failure:
                        break
                    }
                    waitExpectation.fulfill()

                case .fetchInitialPageInList:
                    break

                default:
                    XCTFail("unexpected action")
                }
            }
        )

        // Act

        store.dispatch(.fetchInitialPageInList)
        listRepository.getListsWithPageLengthSearchTextClosure = { (currentPage, pageLength, searchText) in
            Future<[ListModel], Error> { promise in
                promise(.success(expectData))
            }.eraseToAnyPublisher()
        }

        // Assert


        wait(for: [waitExpectation], timeout: 1)
        XCTAssertEqual(expectData, resultData)
        XCTAssertEqual(listRepository.getListsWithPageLengthSearchTextCallsCount, 1)
    }
}

extension MiddlewareListTests {
    func configure(
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
