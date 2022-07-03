//
//  ListRepository.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 18.04.2022.
//

import Combine
import Foundation

public protocol ListRepositoryProtocol: AnyObject {
    func getLists(with currentPage: Int, pageLength: Int, searchText: String?) -> AnyPublisher<[ListModel], Error>
}

final class ListRepository {
    private let networkService: NetworkServiceProtocol
    private let listModelParser: ListModelParserProtocol

    init(
        networkService: NetworkServiceProtocol,
        listModelParser: ListModelParserProtocol
    ) {
        self.networkService = networkService
        self.listModelParser = listModelParser
    }
}

extension ListRepository: ListRepositoryProtocol {
    func getLists(with currentPage: Int, pageLength: Int, searchText: String?) -> AnyPublisher<[ListModel], Error> {
        let baseURL = "https://api.foobar.com"
        let path = "foo/getBar"
        let url = URL(string: baseURL)!.appendingPathComponent(path)

        var body = [
            "start": String(currentPage * pageLength),
            "length": String(pageLength)
        ]
        if let searchText = searchText {
            body["searchText"] = searchText
        }

        let parameters = NetworkRequestParameters(
            url: url,
            authorizationType: .accessToken,
            httpBody: body
        )

        let listResponseData = networkService.get(
            parameters: parameters,
            withType: [ListResponseData].self
        )
        let listModelData = listResponseData
            .map(listModelParser.parse)
        return listModelData.eraseToAnyPublisher()
    }
}
