//
//  MailListState.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 03.07.2022.
//

import Foundation

struct MailListState: Equatable {
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
        var searchText: String?
        var selectedMailID: String?
    }

    var list = List()
}
