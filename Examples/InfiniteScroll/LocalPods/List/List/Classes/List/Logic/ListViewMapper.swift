//
//  ListViewMapper.swift
//  InfiniteScroll
//
//  Created by Dmitrii Cooler on 10.08.2022.
//

import Domain
import Foundation

public extension ListFeature {
    static func getActionMapper(action: ListAction) -> ListAction {
        action
    }

    static func getStateMapper(state: MailState.List) -> MailState.List {
        state
    }
}
