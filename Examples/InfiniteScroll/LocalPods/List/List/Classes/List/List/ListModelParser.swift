//
//  ListModelParser.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 17.04.2022.
//

import Foundation
import Domain

public protocol ListModelParserProtocol {
    func parse(responseData: [ListResponseData]) -> [ListModel]
}

public struct ListModelParser: ListModelParserProtocol {
    public init() {}

    public func parse(
        responseData: [ListResponseData]
    ) -> [ListModel] {
        return responseData.map { responseData in
            let listModel = ListModel(
                title: responseData.title,
                subtitle: responseData.subtitle,
                id: responseData.id,
                details: responseData.details
            )
            return listModel
        }
    }
}
