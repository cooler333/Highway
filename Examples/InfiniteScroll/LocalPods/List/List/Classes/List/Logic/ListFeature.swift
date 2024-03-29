//
//  ListFeature.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 16.04.2022.
//

import Combine
import Domain
import Foundation
import Highway

public enum ListAction: Equatable {
    case initial

    // List
    case fetchInitialPageInList
    case fetchNextPageInList

    public struct ListData: Equatable {
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

public final class ListEnvironment {
    let mainQueue: DispatchQueue = .main
    let backgroundQueue: DispatchQueue = .global(qos: .background)
    let pageLength = 15

    var cancellable = Set<AnyCancellable>()

    let listRepository: ListRepositoryProtocol
    weak var moduleOutput: ListModuleOutput?

    public init(
        listRepository: ListRepositoryProtocol,
        moduleOutput: ListModuleOutput
    ) {
        self.listRepository = listRepository
        self.moduleOutput = moduleOutput
    }
}

public enum ListFeature {}
