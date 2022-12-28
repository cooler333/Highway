//
//  ListViewMapper.swift
//  InfiniteScroll
//
//  Created by Dmitrii Cooler on 10.08.2022.
//

import Foundation
import Domain

extension ListFeature {
    public static func getActionMapper(action: ListAction) -> ListAction {
        action
    }

    public static func getStateMapper(state: MailState.List) -> MailState.List {
        state
    }
}
