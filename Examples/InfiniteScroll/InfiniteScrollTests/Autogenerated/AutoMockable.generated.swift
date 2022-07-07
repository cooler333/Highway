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
















class ListRepositoryProtocolMock: ListRepositoryProtocol {

    // MARK: - getLists

    var getListsWithPageLengthSearchTextCallsCount = 0
    var getListsWithPageLengthSearchTextCalled: Bool {
        return getListsWithPageLengthSearchTextCallsCount > 0
    }
    var getListsWithPageLengthSearchTextReceivedArguments: (currentPage: Int, pageLength: Int, searchText: String?)?
    var getListsWithPageLengthSearchTextReceivedInvocations: [(currentPage: Int, pageLength: Int, searchText: String?)] = []
    var getListsWithPageLengthSearchTextReturnValue: AnyPublisher<[ListModel], Error>!
    var getListsWithPageLengthSearchTextClosure: ((Int, Int, String?) -> AnyPublisher<[ListModel], Error>)?

    func getLists(with currentPage: Int, pageLength: Int, searchText: String?) -> AnyPublisher<[ListModel], Error> {
        getListsWithPageLengthSearchTextCallsCount += 1
        getListsWithPageLengthSearchTextReceivedArguments = (currentPage: currentPage, pageLength: pageLength, searchText: searchText)
        getListsWithPageLengthSearchTextReceivedInvocations.append((currentPage: currentPage, pageLength: pageLength, searchText: searchText))
        if let getListsWithPageLengthSearchTextClosure = getListsWithPageLengthSearchTextClosure {
            return getListsWithPageLengthSearchTextClosure(currentPage, pageLength, searchText)
        } else {
            return getListsWithPageLengthSearchTextReturnValue
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
