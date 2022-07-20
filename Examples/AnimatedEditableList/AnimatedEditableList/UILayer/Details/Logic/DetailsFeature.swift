//
//  DetailsFeature.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway

enum DetailsFeature {}

extension DetailsFeature {}

extension DetailsFeature {
    enum Action {
        case initial
        case insertSection(value: Int)
        case insertRow(value: IndexPath)
        case deleteSection(value: Int)
        case deleteRow(value: IndexPath)
        case updateRow(value: IndexPath)
    }
}

extension DetailsFeature {
    static func reducer() -> Reducer<RootFeature.State, Action> {
        .init { state, action in
            switch action {
            case .initial:
                var state = state
                state.data = [
                    RootFeature.State.Section(
                        id: 0,
                        items: [
                            RootFeature.State.Section.Title(
                                id: UUID().uuidString,
                                value: "Foo"
                            ),
                            RootFeature.State.Section.Details(
                                id: UUID().uuidString,
                                value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
                            ),
                            RootFeature.State.Section.Image(
                                id: UUID().uuidString,
                                value: URL(string: "https://image.shutterstock.com/image-illustration/high-speed-luxury-sedan-driving-600w-1171714909.jpg")!)
                        ]
                    )
                ]
                return state
                
            case let .insertRow(indexPath):
                var state = state
                var items = state.data[indexPath.section].items
                let item = RootFeature.State.Section.Details(
                    id: UUID().uuidString,
                    value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
                )
                items.insert(item, at: indexPath.row+1)
                state.data[indexPath.section].items = items
                return state
            
            case let .insertSection(index):
                var state = state
                let section = RootFeature.State.Section(
                    id: state.data.last!.id + 1,
                    items: [
                        RootFeature.State.Section.Title(
                            id: UUID().uuidString,
                            value: "Foo"
                        ),
                        RootFeature.State.Section.Details(
                            id: UUID().uuidString,
                            value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
                        ),
                        RootFeature.State.Section.Image(
                            id: UUID().uuidString,
                            value: URL(string: "https://image.shutterstock.com/image-illustration/high-speed-luxury-sedan-driving-600w-1171714909.jpg")!)
                    ]
                )
                state.data.insert(section, at: index+1)
                return state
                
            case let .deleteRow(indexPath):
                var state = state
                var items = state.data[indexPath.section].items
                items.remove(at: indexPath.row)
                state.data[indexPath.section].items = items
                return state
                
            case let .deleteSection(index):
                var state = state
                state.data.remove(at: index)
                return state
                
            case let .updateRow(indexPath):
                var state = state
                let items = state.data[indexPath.section].items
                let item = items[indexPath.row]
                switch item {
                case let title as RootFeature.State.Section.Title:
                    state.data[indexPath.section].items[indexPath.row] = RootFeature.State.Section.Details(
                        id: title.id,
                        value: "ID: \(title.id), Type: Details, Value: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
                    )
                    return state

                case let details as RootFeature.State.Section.Details:
                    state.data[indexPath.section].items[indexPath.row] = RootFeature.State.Section.Title(
                        id: details.id,
                        value: "ID: \(details.id), Type: Title, Value: Foo"
                    )
                    return state
                    
                case let image as RootFeature.State.Section.Image:
                    let value: URL
                    if image.value.absoluteString == "https://image.shutterstock.com/image-illustration/high-speed-luxury-sedan-driving-600w-1171714909.jpg" {
                        value = URL(string: "https://image.shutterstock.com/image-vector/side-view-neon-glowing-sport-600w-1387460150.jpg")!
                    } else {
                        value = URL(string: "https://image.shutterstock.com/image-illustration/high-speed-luxury-sedan-driving-600w-1171714909.jpg")!
                    }
                    state.data[indexPath.section].items[indexPath.row] = RootFeature.State.Section.Image(
                        id: image.id,
                        value: value
                    )
                    return state

                default:
                    return state
                }
            }
        }
    }
}
