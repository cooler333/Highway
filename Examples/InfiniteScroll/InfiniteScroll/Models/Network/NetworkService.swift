//
//  NetworkService.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 12.02.2022.
//

import Combine
import Foundation

final class NetworkService {
    private let accessToken: String = ""
    private let session = URLSession(configuration: .ephemeral)
    init() {}
}

extension NetworkService: NetworkServiceProtocol {
    func get<T: Decodable>(
        parameters: NetworkRequestParameters,
        withType type: T.Type
    ) -> AnyPublisher<T, Error> {
        var strs = parameters.httpBody.map { key, value in
            key + "=" + value
        }

        switch parameters.authorizationType {
        case .accessToken:
            strs.append("access_token=\(accessToken)")

        case .none:
            break
        }

        let httpBodyString = strs.joined(separator: "&")

        let newStr = parameters.url.appendingPathComponent("/").absoluteString.appending("?" + httpBodyString)
        let newURL = URL(string: newStr)!

        var request = URLRequest(url: newURL)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let publisher = session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
        return publisher
    }

    func post<T: Decodable>(
        parameters: NetworkRequestParameters,
        withType type: T.Type
    ) -> AnyPublisher<T, Error> {
        var strs = parameters.httpBody.map { key, value in
            key + "=" + value
        }

        switch parameters.authorizationType {
        case .accessToken:
            strs.append("access_token=\(accessToken)")

        case .none:
            break
        }

        let httpBodyString = strs.joined(separator: "&")

        var request = URLRequest(url: parameters.url.appendingPathComponent("/"))
        request.httpBody = httpBodyString.data(using: .utf8)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let publisher = session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
        return publisher
    }
}
