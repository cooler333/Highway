//
//  Subscription.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import Foundation

public struct Subscription<State>: Equatable {
    let listener: (State) -> Void
    private let uuid = UUID()

    public static func == (lhs: Subscription, rhs: Subscription) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
