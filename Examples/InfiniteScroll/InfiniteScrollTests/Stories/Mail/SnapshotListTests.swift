//
//  SnapshotListTests.swift
//  InfiniteScrollTests
//
//  Created by Dmitrii Coolerov on 04.08.2022.
//

import Combine
import Highway
import SnapshotTesting
import Swinject
import XCTest
import Domain
import List

@testable import InfiniteScroll

class SnapshotListTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNotEmptyLoadingList() throws {
        // Arrange

        let container = Container()

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .nextPage,
            data: [
                .init(
                    title: "Foo",
                    subtitle: "Bar",
                    id: "202cb962ac59075b964b07152d234b70",
                    details: "Lorem ipsum"
                ),
            ],
            searchText: nil,
            selectedMailID: nil
        )
        let viewController = configure(state: state, resolver: container)

        // Act
        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

    func testEmptyLoadingList() throws {
        // Arrange

        let container = Container()

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .nextPage,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )
        let viewController = configure(state: state, resolver: container)

        // Act
        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

    func testNotEmptyRefreshList() throws {
        // Arrange

        let container = Container()

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .refresh,
            data: [
                .init(
                    title: "Foo",
                    subtitle: "Bar",
                    id: "202cb962ac59075b964b07152d234b70",
                    details: "Lorem ipsum"
                ),
            ],
            searchText: nil,
            selectedMailID: nil
        )
        let viewController = configure(state: state, resolver: container)

        // Act
        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

    func testEmptyRefreshList() throws {
        // Arrange

        let container = Container()

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .refresh,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )
        let viewController = configure(state: state, resolver: container)

        // Act
        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

    func testNotEmptyList() throws {
        // Arrange

        let container = Container()

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [
                .init(
                    title: "Foo",
                    subtitle: "Bar",
                    id: "202cb962ac59075b964b07152d234b70",
                    details: "Lorem ipsum"
                ),
            ],
            searchText: nil,
            selectedMailID: nil
        )
        let viewController = configure(state: state, resolver: container)

        // Act
        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

    func testNotEmptyEndedList() throws {
        // Arrange

        let container = Container()

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: true,
            loadingState: .idle,
            data: [
                .init(
                    title: "Foo",
                    subtitle: "Bar",
                    id: "202cb962ac59075b964b07152d234b70",
                    details: "Lorem ipsum"
                ),
            ],
            searchText: nil,
            selectedMailID: nil
        )
        let viewController = configure(state: state, resolver: container)

        // Act
        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

    func testNotEmptyErrorList() throws {
        // Arrange

        let container = Container()

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .error(.networkError),
            data: [
                .init(
                    title: "Foo",
                    subtitle: "Bar",
                    id: "202cb962ac59075b964b07152d234b70",
                    details: "Lorem ipsum"
                ),
            ],
            searchText: nil,
            selectedMailID: nil
        )
        let viewController = configure(state: state, resolver: container)

        // Act
        // Assert

        XCTAssertEqual(toastNotificationManager.showNotificationWithCallsCount, 1)
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

    func testEmptyList() throws {
        // Arrange

        let container = Container()

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .idle,
            data: [],
            searchText: nil,
            selectedMailID: nil
        )
        let viewController = configure(state: state, resolver: container)

        // Act
        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

    func testEmptyErrorList() throws {
        // Arrange

        let container = Container()

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        let state: MailState.List = .init(
            currentPage: 0,
            isListEnded: false,
            loadingState: .error(.networkError),
            data: [],
            searchText: nil,
            selectedMailID: nil
        )
        let viewController = configure(state: state, resolver: container)

        // Act
        // Assert

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }
}

extension SnapshotListTests {
    func configure(state: MailState.List, resolver: Resolver) -> UIViewController {
        let store = Store<MailState.List, ListAction>(
            reducer: .init { state, _ in
                state
            },
            state: state
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
        _ = viewController.view

        return viewController
    }
}
