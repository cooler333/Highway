//
//  ListTests.swift
//  InfiniteScrollTests
//
//  Created by Dmitrii Coolerov on 04.08.2022.
//

import Combine
import Highway
import SnapshotTesting
import Swinject
import XCTest

@testable import InfiniteScroll

class ListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmptyList() throws {
        enum ErrorType: Error {
            case nilValue
        }

        // Arrange

        let container = Container()

        let listRepository = ListRepositoryProtocolMock()
        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        let moduleOutput = ListModuleOutputMock()

        container.register(ListRepositoryProtocol.self) { _ in
            listRepository
        }
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let environment = ListEnvironment(
            listRepository: container.resolve(ListRepositoryProtocol.self)!,
            moduleOutput: moduleOutput
        )
        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )
        let store = Store(
            reducer: ListFeature.getReducer(),
            state: state,
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
            toastNotificationManager: container.resolve(ToastNotificationManagerProtocol.self)!
        )

        // Act

        listRepository.getListsWithPageLengthSearchTextClosure = { (currentPage: Int, pageLength: Int, searchText: String?) in
            Future<[ListModel], Error> { promise in
                promise(.success([]))
            }.eraseToAnyPublisher()
        }

        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

    func testNotEmptyList() throws {
        enum ErrorType: Error {
            case nilValue
        }

        // Arrange

        let container = Container()

        let listRepository = ListRepositoryProtocolMock()
        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        let moduleOutput = ListModuleOutputMock()

        container.register(ListRepositoryProtocol.self) { _ in
            listRepository
        }
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let waitExpectation = expectation(description: "wait")

        let testMiddleware: Middleware<MailState.List, ListAction> = createMiddleware(
            { dispatch, getState, action in
                switch action {
                case .updateInitialPageInList:
                    waitExpectation.fulfill()

                default:
                    break
                }
            }
        )
        let environment = ListEnvironment(
            listRepository: container.resolve(ListRepositoryProtocol.self)!,
            moduleOutput: moduleOutput
        )
        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )
        let store = Store(
            reducer: ListFeature.getReducer(),
            state: state,
            initialAction: .initial,
            middleware: ListFeature.getMiddlewares(environment: environment) + [testMiddleware]
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
            toastNotificationManager: container.resolve(ToastNotificationManagerProtocol.self)!
        )

        // Act

        listRepository.getListsWithPageLengthSearchTextClosure = { (currentPage: Int, pageLength: Int, searchText: String?) in
            Future<[ListModel], Error> { promise in
                promise(.success([
                    .init(title: "Foo", subtitle: "Bar", id: UUID().uuidString, details: "Lorem ipsum")
                ]))
            }.eraseToAnyPublisher()
        }
//        store.dispatch(.fetchInitialPageInList)

        wait(for: [waitExpectation], timeout: 20)

        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

}
