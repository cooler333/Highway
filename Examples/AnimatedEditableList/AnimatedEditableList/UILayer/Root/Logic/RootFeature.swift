//
//  RootFeature.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway

enum RootFeature {}

extension RootFeature {
    struct State: Equatable {
        struct Section: Equatable, Hashable {
            var identifier: Int
            var items: [AnyHashable] = []
        }

        var data: [Section] = []
    }
}

extension RootFeature {
    enum Action {
        case initial
        case insertSection(value: Int)
        case insertRow(value: IndexPath)
        case deleteSection(value: Int)
        case deleteRow(value: IndexPath)
        case updateSection(value: Int)
        case updateRow(value: IndexPath)
    }
}

extension RootFeature {
    static func reducer() -> Reducer<RootFeature.State, Action> {
        .init { state, action in
            switch action {
            case .initial:
                var state = state
                state.data = [
                    RootFeature.State.Section(
                        identifier: 0,
                        items: [
                            TitleItem(value: "Foo"),
                            DetailsItem(
                                value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
                            ),
                            ImageItem(value: URL(string: "https://image.shutterstock.com/image-illustration/high-speed-luxury-sedan-driving-600w-1171714909.jpg")!)
                        ]
                    )
                ]
                return state
                
            case let .insertRow(value):
                return state
            
            case let .insertSection(value):
                return state
                
            case let .deleteRow(value):
                var state = state
                var items = state.data[value.section].items
                items.remove(at: value.row)
                state.data[value.section].items = items
                return state
                
            case let .deleteSection(value):
                return state
                
            case let .updateSection(value):
                return state
                
            case let .updateRow(value):
                return state
            }
        }
    }
}
