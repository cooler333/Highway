//
//  MailState.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 03.07.2022.
//

import Foundation

public enum ListAPIError: Error, Equatable {
    case networkError
}

public struct MailState: Equatable {
    public struct List: Equatable {
        public enum LoadingState: Equatable {
            case error(ListAPIError)
            case refresh
            case nextPage
            case idle
        }

        public var currentPage = 0
        public var isListEnded = false
        public var loadingState: LoadingState = .idle
        public var data: [ListModel] = []
        public var searchText: String?
        public var selectedMailID: String?

        public init(
            currentPage: Int = 0,
            isListEnded: Bool = false,
            loadingState: LoadingState = .idle,
            data: [ListModel] = [],
            searchText: String? = nil,
            selectedMailID: String? = nil
        ) {
            self.currentPage = currentPage
            self.isListEnded = isListEnded
            self.loadingState = loadingState
            self.data = data
            self.searchText = searchText
            self.selectedMailID = selectedMailID
        }
    }

    public var list = List()

    public init(
        list: List = List()
    ) {
        self.list = list
    }
}
