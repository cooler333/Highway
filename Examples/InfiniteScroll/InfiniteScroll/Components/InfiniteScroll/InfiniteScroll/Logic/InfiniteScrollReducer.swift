//
//  InfiniteScrollReducer.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 29.06.2022.
//

import Foundation
import Highway

extension InfiniteScrollFeature {
    @inline(__always)
    static func getReducer() -> Reducer<InfiniteScrollState, InfiniteScrollAction> {
        let reducer: Reducer<InfiniteScrollState, InfiniteScrollAction> = { state, action in
            switch action {
            case .fetchInitialPageInList:
                var state = state
                state.list.currentPage = 0
                state.list.loadingState = .refresh
                return state

            case .fetchNextPageInList:
                if state.list.isListEnded {
                    return state
                }
                if state.list.loadingState == .nextPage {
                    return state
                }
                var state = state
                state.list.loadingState = .nextPage
                return state

            case let .updateInitialPageInList(result):
                switch result {
                case let .success(data):
                    var state = state
                    state.list.loadingState = .idle
                    state.list.isListEnded = data.count < state.list.pageLength
                    state.list.currentPage += 1
                    state.list.data = data
                    return state

                case let .failure(error):
                    var state = state
                    state.list.loadingState = .error(error)
                    return state
                }

            case let .search(searchText):
                var state = state
                state.list.data = []
                state.list.loadingState = .refresh
                state.searchText = searchText
                return state

            case .getPageDidCancel:
                return state

            case let .addNextPageInList(result):
                switch result {
                case let .success(data):
                    var state = state
                    state.list.loadingState = .idle
                    state.list.isListEnded = data.count < state.list.pageLength
                    state.list.currentPage += 1
                    state.list.data += data
                    return state

                case let .failure(error):
                    var state = state
                    state.list.loadingState = .error(error)
                    return state
                }

            case .initial,
                    .selectInfiniteScrollAtIndex,
                    .receiveCancelAllRequests,
                    .screenDidOpen:
                return state
            }
        }
        return reducer
    }
}
