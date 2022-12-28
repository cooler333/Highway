//
//  ListModel.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 05.05.2022.
//

import Foundation

public struct ListModel: Hashable {
    public let title: String
    public let subtitle: String
    public let id: String
    public let details: String

    public init(title: String, subtitle: String, id: String, details: String) {
        self.title = title
        self.subtitle = subtitle
        self.id = id
        self.details = details
    }
}
