//
//  InfiniteScrollRepository.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 18.04.2022.
//

import Combine
import Foundation

public protocol InfiniteScrollRepositoryProtocol: AnyObject {
    func getInfiniteScrolls(with currentPage: Int, pageLength: Int, searchText: String?) -> AnyPublisher<[InfiniteScrollModel], Error>
}

final class InfiniteScrollRepository {
    private let networkService: NetworkServiceProtocol
    private let infiniteScrollModelParser: InfiniteScrollModelParserProtocol

    init(
        networkService: NetworkServiceProtocol,
        infiniteScrollModelParser: InfiniteScrollModelParserProtocol
    ) {
        self.networkService = networkService
        self.infiniteScrollModelParser = infiniteScrollModelParser
    }
}

extension InfiniteScrollRepository: InfiniteScrollRepositoryProtocol {
    func getInfiniteScrolls(with currentPage: Int, pageLength: Int, searchText: String?) -> AnyPublisher<[InfiniteScrollModel], Error> {
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

        let infiniteScrollResponseData = networkService.get(
            parameters: parameters,
            withType: [InfiniteScrollResponseData].self
        )
        let infiniteScrollModelData = infiniteScrollResponseData
            .map(infiniteScrollModelParser.parse)
        return infiniteScrollModelData.eraseToAnyPublisher()
    }
}
