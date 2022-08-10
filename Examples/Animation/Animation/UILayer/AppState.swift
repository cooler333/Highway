//
//  AppState.swift
//  Animation
//
//  Created by Dmitrii Coolerov on 17.07.2022.
//

import Foundation

struct AppState {
    enum State {
        case normal
        case highlighted
        case disabled
    }

    struct BoolData: Equatable {
        var id: String
        var isOn: Bool
        var state: State
    }

    struct SegmentData: Equatable {
        var id: String
        var segments: [String]
        var selectedIndex: Int
        var state: State
    }

    struct HeaderData: Equatable {
        var id: String
        var title: String
    }

    enum DataType: Equatable {
        case boolData(BoolData)
        case segmentData(SegmentData)
        case headerData(HeaderData)
    }

    struct Section: Equatable {
        var id: String
        var value: String
        var data: [DataType] = []
    }

    var data: [Section] = []

    var shouldReset = false
}

extension AppState: Equatable {}
