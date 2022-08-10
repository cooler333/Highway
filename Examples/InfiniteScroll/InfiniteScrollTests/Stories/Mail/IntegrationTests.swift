//
//  IntegrationTests.swift
//  InfiniteScrollTests
//
//  Created by Dmitrii Cooler on 10.08.2022.
//

import Combine
import Highway
import Swinject
import XCTest

@testable import Highway
@testable import InfiniteScroll

// swiftlint:disable:next type_body_length
class ListTests: XCTestCase {
    var listRepository: ListRepositoryProtocolMock!
    var listModuleOutput: ListModuleOutputMock!

    var viewStore: ViewStore<MailState.List, ListAction>!
    var viewController: UIViewController!

    var cancellable = Set<AnyCancellable>()

    var eventPublusher = PassthroughSubject<ListAction, Never>()

    override func setUpWithError() throws {
        let container = Container()
        let resolver: Resolver = container

        listRepository = ListRepositoryProtocolMock()
        container.register(ListRepositoryProtocol.self) { _ in
            self.listRepository
        }

        let toastNotificationManager = ToastNotificationManagerProtocolMock()
        toastNotificationManager.showNotificationWithClosure = { _ in
            // unused
        }
        container.register(ToastNotificationManagerProtocol.self) { _ in
            toastNotificationManager
        }

        listModuleOutput = ListModuleOutputMock()
        container.register(ListModuleOutput.self) { _ in
            self.listModuleOutput
        }

        let testReducer = Reducer<MailState.List, ListAction> { state, event in
            self.eventPublusher.send(event)
            return ListFeature.getReducer().reduce(state, event)
        }

        let store = Store<MailState.List, ListAction>(
            reducer: testReducer,
            state: MailState.List(),
            middleware: ListFeature.getMiddlewares(
                environment: ListEnvironment(
                    listRepository: resolver.resolve(ListRepositoryProtocol.self)!,
                    moduleOutput: resolver.resolve(ListModuleOutput.self)!
                )
            )
        )

        viewStore = ViewStore<MailState.List, ListAction>(
            store: store,
            stateMapper: ListFeature.getStateMapper,
            actionMapper: ListFeature.getActionMapper
        )

        viewController = ListViewController(
            store: viewStore,
            toastNotificationManager: resolver.resolve(ToastNotificationManagerProtocol.self)!
        )
    }

    override func tearDownWithError() throws {
        // unused
    }

    // TODO: conver to middleware/reducer or snapshot/ui test
    // swiftlint:disable:next function_body_length
    func testNextPage() throws {
//        // Arrange
//        let finalExpectation = expectation(description: "final")
//
//        eventPublusher.sink { event in
//            if event == .updateInitialPageInList(
//                data: (0...14).map { index in
//                    ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//                },
//                isListEnded: false
//            ) {
//                // swiftlint:disable:next line_length
//                self.listRepository.getListsWithPageLengthSearchTextReturnValue = Future<[ListModel], Error>({ promise in
//                    let data = (15...15).map { index in
//                        ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    }
//                    promise(.success(data))
//                }).eraseToAnyPublisher()
//                self.viewStore.dispatch(.fetchNextPageInList)
//            }
//        }.store(in: &cancellable)
//
//        var states: [MailState.List] = []
//        viewStore.statePublisher.sink { state in
//            states.append(state)
//
//            let finalState = MailState.List(
//                contentState: .content(
//                    data: (0...15).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: true
//                )
//            )
//            if state == finalState {
//                finalExpectation.fulfill()
//            }
//        }.store(in: &cancellable)
//
//        // Act
//        // swiftlint:disable:next line_length
//        listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//            let data = (0...14).map { index in
//                ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//            }
//            promise(.success(data))
//        }).eraseToAnyPublisher()
//        viewStore.dispatch(.viewDidLoad)
//
//        // Assert
//        wait(for: [finalExpectation], timeout: 1)
//
//        let referenseStates: [MailState.List] = [
//            MailState.List(
//                contentState: .content(
//                    data: [],
//                    isListEnded: false
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: [],
//                    state: .refresh
//                )
//            ),
//            MailState.List(
//                contentState: .content(
//                    data: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    state: .nextPage
//                )
//            ),
//            MailState.List(
//                contentState: .content(
//                    data: (0...15).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: true
//                )
//            ),
//        ]
//        XCTAssertEqual(states, referenseStates)
    }

    // swiftlint:disable:next function_body_length
    func testRefresh() throws {
        // Arrange
//        let finalExpectation = expectation(description: "final")
//
//        eventPublusher.sink { event in
//            if event == .updateInitialData(
//                data: (0...14).map { index in
//                    ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//                },
//                isListEnded: false
//            ) {
//                // swiftlint:disable:next line_length
//                self.listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//                    let data = (15...20).map { index in
//                        ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    }
//                    promise(.success(data))
//                }).eraseToAnyPublisher()
//                self.viewStore.dispatch(.viewDidPullToRefresh)
//            }
//        }.store(in: &cancellable)
//
//        var states: [MailState.List] = []
//        viewStore.statePublisher.sink { state in
//            states.append(state)
//
//            let finalState = MailState.List(
//                contentState: .content(
//                    data: (15...20).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: true
//                )
//            )
//            if state == finalState {
//                finalExpectation.fulfill()
//            }
//        }.store(in: &cancellable)
//
//        // Act
//        // swiftlint:disable:next line_length
//        listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//            let data = (0...14).map { index in
//                ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//            }
//            promise(.success(data))
//        }).eraseToAnyPublisher()
//        viewStore.dispatch(.viewDidLoad)
//
//        // Assert
//        wait(for: [finalExpectation], timeout: 1)
//
//        let referenseStates: [MailState.List] = [
//            MailState.List(
//                contentState: .content(
//                    data: [],
//                    isListEnded: false
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: [],
//                    state: .refresh
//                )
//            ),
//            MailState.List(
//                contentState: .content(
//                    data: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    state: .refresh
//                )
//            ),
//            MailState.List(
//                contentState: .content(
//                    data: (15...20).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: true
//                )
//            ),
//        ]
//        XCTAssertEqual(states, referenseStates)
    }

    // swiftlint:disable:next function_body_length
    func testNextPageError() throws {
        // Arrange
//        let finalExpectation = expectation(description: "final")
//
//        eventPublusher.sink { event in
//            if event == .updateInitialData(
//                data: (0...14).map { index in
//                    ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//                },
//                isListEnded: false
//            ) {
//                // swiftlint:disable:next line_length
//                self.listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//                    promise(.failure(URLError(.notConnectedToInternet)))
//                }).eraseToAnyPublisher()
//                self.viewStore.dispatch(.viewWillScrollToLastItem)
//            }
//        }.store(in: &cancellable)
//
//        var states: [MailState.List] = []
//        viewStore.statePublisher.sink { state in
//            states.append(state)
//
//            let finalState = MailState.List(
//                contentState: .error(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false,
//                    error: .api
//                )
//            )
//            if state == finalState {
//                finalExpectation.fulfill()
//            }
//        }.store(in: &cancellable)
//
//        // Act
//        // swiftlint:disable:next line_length
//        listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//            let data = (0...14).map { index in
//                ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//            }
//            promise(.success(data))
//        }).eraseToAnyPublisher()
//        viewStore.dispatch(.viewDidLoad)
//
//        // Assert
//        wait(for: [finalExpectation], timeout: 1)
//
//        let referenseStates: [MailState.List] = [
//            MailState.List(
//                contentState: .content(
//                    data: [],
//                    isListEnded: false
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: [],
//                    state: .refresh
//                )
//            ),
//            MailState.List(
//                contentState: .content(
//                    data: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    state: .nextPage
//                )
//            ),
//            MailState.List(
//                contentState: .error(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false,
//                    error: .api
//                )
//            ),
//        ]
//        XCTAssertEqual(states, referenseStates)
    }

    // swiftlint:disable:next function_body_length
    func testRefreshError() throws {
        // Arrange
//        let finalExpectation = expectation(description: "final")
//
//        eventPublusher.sink { event in
//            if event == .updateInitialData(
//                data: (0...14).map { index in
//                    ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//                },
//                isListEnded: false
//            ) {
//                // swiftlint:disable:next line_length
//                self.listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//                    promise(.failure(URLError(.notConnectedToInternet)))
//                }).eraseToAnyPublisher()
//                self.viewStore.dispatch(.viewDidPullToRefresh)
//            }
//        }.store(in: &cancellable)
//
//        var states: [MailState.List] = []
//        viewStore.statePublisher.sink { state in
//            states.append(state)
//
//            let finalState = MailState.List(
//                contentState: .error(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false,
//                    error: .api
//                )
//            )
//            if state == finalState {
//                finalExpectation.fulfill()
//            }
//        }.store(in: &cancellable)
//
//        // Act
//        // swiftlint:disable:next line_length
//        listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//            let data = (0...14).map { index in
//                ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//            }
//            promise(.success(data))
//        }).eraseToAnyPublisher()
//        viewStore.dispatch(.viewDidLoad)
//
//        // Assert
//        wait(for: [finalExpectation], timeout: 1)
//
//        let referenseStates: [MailState.List] = [
//            MailState.List(
//                contentState: .content(
//                    data: [],
//                    isListEnded: false
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: [],
//                    state: .refresh
//                )
//            ),
//            MailState.List(
//                contentState: .content(
//                    data: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    state: .refresh
//                )
//            ),
//            MailState.List(
//                contentState: .error(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false,
//                    error: .api
//                )
//            ),
//        ]
//        XCTAssertEqual(states, referenseStates)
    }

    // swiftlint:disable:next function_body_length
    func testRetryLoadNextPageOnError() throws {
        // Arrange
//        let finalExpectation = expectation(description: "final")
//
//        eventPublusher.sink { event in
//            if event == .updateInitialData(
//                data: (0...14).map { index in
//                    ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//                },
//                isListEnded: false
//            ) {
//                // swiftlint:disable:next line_length
//                self.listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//                    promise(.failure(URLError(.notConnectedToInternet)))
//                }).eraseToAnyPublisher()
//                self.viewStore.dispatch(.viewWillScrollToLastItem)
//            }
//
//            if event == .updateDataWithError(error: .networkError) {
//                // swiftlint:disable:next line_length
//                self.listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//                    let data = (15...20).map { index in
//                        ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    }
//                    promise(.success(data))
//                }).eraseToAnyPublisher()
//                self.viewStore.dispatch(.viewDidTapRetryNextPageLoading)
//            }
//        }.store(in: &cancellable)
//
//        var states: [MailState.List] = []
//        viewStore.statePublisher.sink { state in
//            states.append(state)
//
//            let finalState = MailState.List(
//                contentState: .content(
//                    data: (0...20).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: true
//                )
//            )
//            if state == finalState {
//                finalExpectation.fulfill()
//            }
//        }.store(in: &cancellable)
//
//        // Act
//        // swiftlint:disable:next line_length
//        listRepository.getListsWithPageLengthReturnValue = Future<[ListModel], Error>({ promise in
//            let data = (0...14).map { index in
//                ListModel(title: "\(index)", subtitle: "", id: "", details: "")
//            }
//            promise(.success(data))
//        }).eraseToAnyPublisher()
//        viewStore.dispatch(.viewDidLoad)
//
//        // Assert
//        wait(for: [finalExpectation], timeout: 20)
//
//        let referenseStates: [MailState.List] = [
//            MailState.List(contentState: .content(data: [], isListEnded: false)),
//            MailState.List(contentState: .loading(
//                previousData: [],
//                state: List.LCEPagedLoadingState.refresh
//            )),
//            MailState.List(
//                contentState: .content(
//                    data: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    state: .nextPage
//                )
//            ),
//            MailState.List(
//                contentState: .error(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: false,
//                    error: .api
//                )
//            ),
//            MailState.List(
//                contentState: .loading(
//                    previousData: (0...14).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    state: .nextPage
//                )
//            ),
//            MailState.List(
//                contentState: .content(
//                    data: (0...20).map { index in
//                        ListViewModel(title: "\(index)", subtitle: "", id: "", details: "")
//                    },
//                    isListEnded: true
//                )
//            ),
//        ]
//        XCTAssertEqual(states, referenseStates)
    }
    // swiftlint:disable:next file_length
}
