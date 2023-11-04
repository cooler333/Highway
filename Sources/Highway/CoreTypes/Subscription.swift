//
//  Nofifier.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import Foundation

public final class Nofifier<Value> {
    private var subscriptions: [Subscription<Value>]

    public init() {
        self.subscriptions = []
    }

    public init(subscriptions: [Subscription<Value>]) {
        self.subscriptions = subscriptions
    }

    @discardableResult
    public func subscribe(listener: @escaping (Value) -> Void) -> Subscription<Value> {
        let subscription = Subscription<Value>(listener: listener)
        subscriptions.append(subscription)
        return subscription
    }

    @discardableResult
    public func unsubscribe(_ subscription: Subscription<Value>) -> Bool {
        if let index = subscriptions.firstIndex(of: subscription) {
            subscriptions.remove(at: index)
            return true
        }
        return false
    }

    public func publish(newValue: Value) {
        subscriptions.forEach { subscription in
            subscription.listener(newValue)
        }
    }
}

public struct Subscription<State>: Equatable {
    let listener: (State) -> Void
    private let uuid = UUID()

    public static func == (lhs: Subscription, rhs: Subscription) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
