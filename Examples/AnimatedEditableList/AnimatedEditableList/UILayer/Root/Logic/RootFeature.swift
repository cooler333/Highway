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
        var data: [SectionItem] = []
    }
    
    struct SectionItem: Hashable {
        let id: Int
        var items: [AnyHashable]

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            items.forEach { anyHashable in
                hasher.combine(anyHashable)
            }
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }

    struct TitleItem: Hashable {
        let id: UUID
        let value: String
        
        init(id: UUID, value: String) {
            self.id = id
            self.value = value
        }

        init(value: String) {
            self.id = UUID()
            self.value = value
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.value == rhs.value
        }
    }

    struct DetailsItem: Hashable {
        let id = UUID()
        let value: String

        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.value == rhs.value
        }
    }

    struct ImageItem: Hashable {
        let id = UUID()
        
        let value: URL
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.value == rhs.value
        }
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
                    SectionItem(
                        id: 0,
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
                
            case let .updateRow(indexPath):
                var state = state
                let items = state.data[indexPath.section].items
                let item = items[indexPath.row]
                switch item {
                case let titleItem as TitleItem:
                    let value = titleItem.value + " " + titleItem.value
                    state.data[indexPath.section].items[indexPath.row] = TitleItem(value: value)
                    
                default:
                    break
                }
                return state
            }
        }
    }
}
