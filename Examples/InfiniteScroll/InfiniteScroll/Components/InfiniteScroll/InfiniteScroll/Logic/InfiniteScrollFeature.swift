//
//  InfiniteScrollFeature.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 16.04.2022.
//

import Combine
import Foundation
import Highway

struct InfiniteScrollState: Equatable {
    struct List: Equatable {
        enum LoadingState: Equatable {
            case error(InfiniteScrollAPIError)
            case refresh
            case nextPage
            case idle
        }

        let pageLength = 15
        var currentPage = 0
        var isListEnded = false
        var loadingState: LoadingState = .idle
        var data: [InfiniteScrollModel] = []
    }

    var list = List()
    var searchText: String?
}

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
    weak var moduleOutput: InfiniteScrollModuleOutput?
}
