//
//  ListModelParser.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 17.04.2022.
//

import Foundation

protocol ListModelParserProtocol {
    func parse(responseData: [ListResponseData]) -> [ListModel]
}

struct ListModelParser: ListModelParserProtocol {
    func parse(
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
