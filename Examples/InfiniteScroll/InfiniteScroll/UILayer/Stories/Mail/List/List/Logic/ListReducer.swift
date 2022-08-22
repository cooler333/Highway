//
//  ListReducer.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 29.06.2022.
//

import Foundation
import Highway

extension ListFeature {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    static func getReducer() -> Reducer<MailState.List, ListAction> {
        return Reducer<MailState.List, ListAction> { state, action in
            switch action {
            case .fetchInitialPageInList:
                var state = state
                state.currentPage = 0
                state.loadingState = .refresh
                return state

            case .fetchNextPageInList:
                if state.isListEnded {
                    assertionFailure("unexpected state")
                    return state
                }
                if state.loadingState == .nextPage {
                    assertionFailure("unexpected state")
                    return state
                }
                var state = state
                state.loadingState = .nextPage
                return state

            case let .updateInitialPageInList(result):
                switch result {
                case let .success(data):
                    var state = state
                    state.loadingState = .idle
                    state.isListEnded = data.isListEnded
                    if !data.isListEnded {
                        state.currentPage += 1
                    }
                    state.data = data.data
                    return state

                case let .failure(error):
                    var state = state
                    state.loadingState = .error(error)
                    return state
                }

            case let .search(searchText):
                var state = state
                state.data = []
                state.loadingState = .refresh
                state.searchText = searchText
                return state

            case .getPageDidCancel:
                return state

            case let .addNextPageInList(result):
                switch result {
                case let .success(data):
                    var state = state
                    state.loadingState = .idle
                    state.isListEnded = data.isListEnded
                    if !data.isListEnded {
                        state.currentPage += 1
                    }
                    state.data += data.data
                    return state

                case let .failure(error):
                    var state = state
                    state.loadingState = .error(error)
                    return state
                }

            case let .selectListAtIndex(index):
                var state = state
                let model = state.data[index]
                state.selectedMailID = model.id
                return state

            case .initial,
                 .receiveCancelAllRequests,
                 .screenDidOpen:
                return state
            }
        }
    }
}
