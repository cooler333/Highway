//
//  Synchronized.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import Foundation

//  https://basememara.com/creating-thread-safe-generic-values-in-swift/
struct Synchronized<Value> {
    private let mutex = DispatchQueue(label: "com.highway.synchronized", attributes: .concurrent)
    private var _value: Value

    init(_ value: Value) {
        self._value = value
    }

    var value: Value { return mutex.sync { return _value } }

    mutating func value<T>(execute task: (inout Value) throws -> T) rethrows -> T {
        return try mutex.sync(flags: .barrier) { return try task(&_value) }
    }
}
