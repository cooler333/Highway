//
//  ContentHashable.swift
//  Animation
//
//  Created by Dmitrii Cooler on 31.07.2022.
//

import Foundation

struct ContentIdentifier: Identifiable, Hashable {
    let id: String
    let contentHashValue: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

struct ContentSectionIdentifier: Identifiable, Hashable {
    let id: String
    let contentHashValue: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

protocol ContentHashable {
    var contentHashValue: Int { get }
}
