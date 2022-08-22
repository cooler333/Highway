//
//  ListFeature.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 16.04.2022.
//

import Combine
import Foundation
import Highway

enum ListAction: Equatable {
    case initial

    // List
    case fetchInitialPageInList
    case fetchNextPageInList

    struct ListData: Equatable {
        let data: [ListModel]
        let isListEnded: Bool
    }
    case updateInitialPageInList(result: Result<ListData, ListAPIError>)
    case addNextPageInList(result: Result<ListData, ListAPIError>)

    case search(searchText: String?)
    case getPageDidCancel(searchText: String?)

    case selectListAtIndex(index: Int)

    // Routing
    case screenDidOpen

    // Other
    case receiveCancelAllRequests
}

enum ListAPIError: Error, Equatable {
    case networkError
}

final class ListEnvironment {
    let mainQueue: DispatchQueue = .main
    let backgroundQueue: DispatchQueue = .global(qos: .background)
    let pageLength = 15

    var cancellable = Set<AnyCancellable>()

    let listRepository: ListRepositoryProtocol
    weak var moduleOutput: ListModuleOutput?

    init(
        listRepository: ListRepositoryProtocol,
        moduleOutput: ListModuleOutput
    ) {
        self.listRepository = listRepository
        self.moduleOutput = moduleOutput
    }
}

enum ListFeature {}
