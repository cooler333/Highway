// Generated using Sourcery 1.8.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import InfiniteScroll
import Combine
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
















class InfiniteScrollRepositoryProtocolMock: InfiniteScrollRepositoryProtocol {

    // MARK: - getInfiniteScrolls

    var getInfiniteScrollsWithPageLengthSearchTextCallsCount = 0
    var getInfiniteScrollsWithPageLengthSearchTextCalled: Bool {
        return getInfiniteScrollsWithPageLengthSearchTextCallsCount > 0
    }
    var getInfiniteScrollsWithPageLengthSearchTextReceivedArguments: (currentPage: Int, pageLength: Int, searchText: String?)?
    var getInfiniteScrollsWithPageLengthSearchTextReceivedInvocations: [(currentPage: Int, pageLength: Int, searchText: String?)] = []
    var getInfiniteScrollsWithPageLengthSearchTextReturnValue: AnyPublisher<[InfiniteScrollModel], Error>!
    var getInfiniteScrollsWithPageLengthSearchTextClosure: ((Int, Int, String?) -> AnyPublisher<[InfiniteScrollModel], Error>)?

    func getInfiniteScrolls(with currentPage: Int, pageLength: Int, searchText: String?) -> AnyPublisher<[InfiniteScrollModel], Error> {
        getInfiniteScrollsWithPageLengthSearchTextCallsCount += 1
        getInfiniteScrollsWithPageLengthSearchTextReceivedArguments = (currentPage: currentPage, pageLength: pageLength, searchText: searchText)
        getInfiniteScrollsWithPageLengthSearchTextReceivedInvocations.append((currentPage: currentPage, pageLength: pageLength, searchText: searchText))
        if let getInfiniteScrollsWithPageLengthSearchTextClosure = getInfiniteScrollsWithPageLengthSearchTextClosure {
            return getInfiniteScrollsWithPageLengthSearchTextClosure(currentPage, pageLength, searchText)
        } else {
            return getInfiniteScrollsWithPageLengthSearchTextReturnValue
        }
    }
}
class ToastNotificationManagerProtocolMock: ToastNotificationManagerProtocol {

    // MARK: - showNotification

    var showNotificationWithCallsCount = 0
    var showNotificationWithCalled: Bool {
        return showNotificationWithCallsCount > 0
    }
    var showNotificationWithReceivedType: ToastNotificationType?
    var showNotificationWithReceivedInvocations: [ToastNotificationType] = []
    var showNotificationWithClosure: ((ToastNotificationType) -> Void)?

    func showNotification(with type: ToastNotificationType) {
        showNotificationWithCallsCount += 1
        showNotificationWithReceivedType = type
        showNotificationWithReceivedInvocations.append(type)
        showNotificationWithClosure?(type)
    }
}
