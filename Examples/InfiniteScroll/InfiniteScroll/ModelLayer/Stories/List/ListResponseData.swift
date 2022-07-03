//
//  ListResponseData.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 17.03.2022.
//

import Foundation

public struct ListResponseData: Decodable {
    public let title: String
    public let subtitle: String
    public let id: String
    public let details: String
}
