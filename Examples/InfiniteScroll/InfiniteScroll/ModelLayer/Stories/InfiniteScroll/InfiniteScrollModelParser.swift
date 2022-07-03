//
//  InfiniteScrollModelParser.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 17.04.2022.
//

import Foundation

protocol InfiniteScrollModelParserProtocol {
    func parse(responseData: [InfiniteScrollResponseData]) -> [InfiniteScrollModel]
}

struct InfiniteScrollModelParser: InfiniteScrollModelParserProtocol {
    func parse(
        responseData: [InfiniteScrollResponseData]
    ) -> [InfiniteScrollModel] {
        return responseData.map { responseData in
            let infiniteScrollModel = InfiniteScrollModel(
                title: responseData.title,
                subtitle: responseData.subtitle,
                id: responseData.id,
                details: responseData.details
            )
            return infiniteScrollModel
        }
    }
}
