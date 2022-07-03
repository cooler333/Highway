//
//  InfiniteScrollFeature.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 16.04.2022.
//

import Combine
import Foundation
import Highway

enum InfiniteScrollAction: Equatable {
    case initial

    // List
    case fetchInitialPageInList
    case fetchNextPageInList
    case updateInitialPageInList(data: Result<[InfiniteScrollModel], InfiniteScrollAPIError>)
    case addNextPageInList(data: Result<[InfiniteScrollModel], InfiniteScrollAPIError>)

    case search(searchText: String?)
    case getPageDidCancel(searchText: String?)

    case selectInfiniteScrollAtIndex(index: Int)

    // Routing
    case screenDidOpen

    // Other
    case receiveCancelAllRequests
}

enum InfiniteScrollAPIError: Error, Equatable {
    case networkError
}

struct InfiniteScrollEnvironment {
    let mainQueue: DispatchQueue = .main
    let backgroundQueue: DispatchQueue = .global(qos: .background)

    let infiniteScrollRepository: InfiniteScrollRepositoryProtocol
    weak var moduleOutput: ListModuleOutput?
}
