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
    case updateInitialPageInList(data: Result<[ListModel], ListAPIError>)
    case addNextPageInList(data: Result<[ListModel], ListAPIError>)

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

struct ListEnvironment {
    let mainQueue: DispatchQueue = .main
    let backgroundQueue: DispatchQueue = .global(qos: .background)

    let listRepository: ListRepositoryProtocol
    weak var moduleOutput: ListModuleOutput?
}

enum ListFeature {}
