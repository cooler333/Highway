//
//  NetworkServiceProtocol.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 05.05.2022.
//

import Combine
import Foundation

public enum NetworkAuthorizationType {
    case accessToken
}

public struct NetworkRequestParameters {
    let url: URL
    let authorizationType: NetworkAuthorizationType?
    let httpBody: [String: String]

    public init(
        url: URL,
        authorizationType: NetworkAuthorizationType?,
        httpBody: [String: String]
    ) {
        self.url = url
        self.authorizationType = authorizationType
        self.httpBody = httpBody
    }
}

public protocol NetworkServiceProtocol {
    func get<T: Decodable>(
        parameters: NetworkRequestParameters,
        withType type: T.Type
    ) -> AnyPublisher<T, Error>

    func post<T: Decodable>(
        parameters: NetworkRequestParameters,
        withType type: T.Type
    ) -> AnyPublisher<T, Error>
}
