//
//  Models+ContentHashable.swift
//  Animation
//
//  Created by Dmitrii Cooler on 31.07.2022.
//

import Foundation

extension AppState.Section: ContentHashable, Identifiable {
    var contentHashValue: Int {
        var hasher = Hasher()
        hasher.combine(value)
        return hasher.finalize()
    }
}

extension AppState.HeaderData: ContentHashable, Identifiable {
    var contentHashValue: Int {
        var hasher = Hasher()
        hasher.combine(title)
        return hasher.finalize()
    }
}

extension AppState.SegmentData: ContentHashable, Identifiable {
    var contentHashValue: Int {
        var hasher = Hasher()
        hasher.combine(segments)
        hasher.combine(selectedIndex)
        hasher.combine(state)
        return hasher.finalize()
    }
}

extension AppState.BoolData: ContentHashable, Identifiable {
    var contentHashValue: Int {
        var hasher = Hasher()
        hasher.combine(isOn)
        hasher.combine(state)
        return hasher.finalize()
    }
}

extension AppState.DataType: ContentHashable, Identifiable {
    var id: String {
        switch self {
        case let .headerData(headerData):
            return headerData.id

        case let .boolData(boolData):
            return boolData.id

        case let .segmentData(segmentData):
            return segmentData.id
        }
    }

    var contentHashValue: Int {
        switch self {
        case let .headerData(headerData):
            return headerData.contentHashValue

        case let .boolData(boolData):
            return boolData.contentHashValue

        case let .segmentData(segmentData):
            return segmentData.contentHashValue
        }
    }
}
