//
//  ListRepository.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 18.04.2022.
//

import Combine
import Foundation

final class ListRepositoryMock {}

extension ListRepositoryMock: ListRepositoryProtocol {
    func getLists(with currentPage: Int, pageLength: Int, searchText: String?) -> AnyPublisher<[ListModel], Error> {
        let pageLengthRandom = Int.random(in: 0...4)
        let internalPageLength = pageLengthRandom != 0 ? pageLength : Int(round(Double(pageLength / 2)))

        if currentPage == 0 {
            let refreshRandom = Int.random(in: 0...5)
            let refreshError = refreshRandom == 0

            return Future<[ListModel], Error> { promise in
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) {
                    if refreshError {
                        promise(.failure(URLError(.notConnectedToInternet)))
                    } else {
                        promise(.success(self.generateModels(
                            count: internalPageLength,
                            searchText: searchText
                        )))
                    }
                }
            }.eraseToAnyPublisher()
        } else {
            let nextPageRandom = Int.random(in: 0...2)
            let nextPageError = nextPageRandom == 0

            return Future<[ListModel], Error> { promise in
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) {
                    if nextPageError {
                        promise(.failure(URLError(.notConnectedToInternet)))
                    } else {
                        promise(.success(self.generateModels(count: internalPageLength, searchText: searchText)))
                    }
                }
            }.eraseToAnyPublisher()
        }
    }

    private func generateModels(count: Int, searchText: String?) -> [ListModel] {
        var data: [ListModel] = []
        (0...count).forEach { _ in
            data.append(generateModel(searchText: searchText))
        }
        return data
    }

    private func generateModel(searchText: String?) -> ListModel {
        ListModel(
            title: searchText ?? "Title" + "\n" + UUID().uuidString.lowercased(),
            subtitle: "Subtitle " + UUID().uuidString.lowercased(),
            id: UUID().uuidString,
            details: "Lorem ipsum" + UUID().uuidString.lowercased()
        )
    }
}
