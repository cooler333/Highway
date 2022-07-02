//
//  FlowCoordinatorProtocol.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 01.02.2022.
//

import Foundation

public enum FlowCoordinatorState {
    case created
    case started
    case forcedClosed
    case finished
}

public protocol FlowCoordinatorProtocol {
    var state: FlowCoordinatorState { get }
    func start()
    func finish(compltion: @escaping () -> Void)
    func handleDeeplink(with url: URL)
}
