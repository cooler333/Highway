//
//  RootFeature.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway

enum RootFeature {

    enum Action {
        case initial
        case setOn(id: String)
        case setOff(id: String)
        case setSegment(index: Int, id: String)
        case resetAll
        case resetted
    }

    static func getReducer() -> Reducer<AppState, Action> {
        .init { state, action in
            switch action {
            case .initial:
                var state = state
                state.data = [
                    .init(id: UUID().uuidString, value: "First", data: [
                        .headerData(.init(id: UUID().uuidString, title: "First")),
                        .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                        .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                        .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                        .segmentData(.init(id: UUID().uuidString, segments: ["foo", "bar", "baz"], selectedIndex: 0, state: .normal)),
                    ]),
                    .init(id: UUID().uuidString, value: "Second", data: [
                        .headerData(.init(id: UUID().uuidString, title: "Second")),
                        .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                        .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                        .boolData(.init(id: UUID().uuidString, isOn: false, state: .normal)),
                        .segmentData(.init(id: UUID().uuidString, segments: ["foo", "bar", "baz"], selectedIndex: 2, state: .normal)),
                    ]),
                ]
                return state

            case let .setOn(value):
                var state = state
                state.data = state.data.map { section -> AppState.Section in
                    var section = section
                    let data = section.data.map { dataType -> AppState.DataType in
                        switch dataType {
                        case .headerData:
                            return dataType

                        case let .boolData(boolData):
                            var boolData = boolData
                            boolData.isOn = true
                            if boolData.id == value {
                                boolData.state = .normal
                            } else {
                                boolData.state = .disabled
                            }
                            return .boolData(boolData)

                        case var .segmentData(segmentData):
                            segmentData.selectedIndex += 1
                            if segmentData.selectedIndex >= segmentData.segments.count {
                                segmentData.selectedIndex = 0
                            }

                            // update section title
                            if section.value != "Second" {
                                section.value = segmentData.segments[segmentData.selectedIndex]
                            }

                            return .segmentData(segmentData)
                        }
                    }
                    section.data = data
                    return section
                }
                state.data = state.data.map { section -> AppState.Section in
                    var section = section
                    let data = section.data.map { dataType -> AppState.DataType in
                        switch dataType {
                        case let .headerData(headerData):
                            var headerData = headerData
                            headerData.title = section.value
                            return .headerData(headerData)

                        case .segmentData, .boolData:
                            return dataType
                        }
                    }
                    section.data = data
                    return section
                }
                return state

            case let .setOff(value):
                var state = state
                state.data = state.data.map { section -> AppState.Section in
                    var section = section
                    let data = section.data.map { dataType -> AppState.DataType in
                        switch dataType {
                        case .headerData:
                            return dataType

                        case let .boolData(boolData):
                            var boolData = boolData
                            boolData.isOn = false
                            if boolData.id == value {
                                boolData.state = .normal
                            } else {
                                boolData.state = .disabled
                            }
                            return .boolData(boolData)

                        case var .segmentData(segmentData):
                            segmentData.selectedIndex += 1
                            if segmentData.selectedIndex >= segmentData.segments.count {
                                segmentData.selectedIndex = 0
                            }

                            // update section title
                            if section.value != "Second" {
                                section.value = segmentData.segments[segmentData.selectedIndex]
                            }

                            return .segmentData(segmentData)
                        }
                    }
                    section.data = data
                    return section
                }
                state.data = state.data.map { section -> AppState.Section in
                    var section = section
                    let data = section.data.map { dataType -> AppState.DataType in
                        switch dataType {
                        case let .headerData(headerData):
                            var headerData = headerData
                            headerData.title = section.value
                            return .headerData(headerData)

                        case .segmentData, .boolData:
                            return dataType
                        }
                    }
                    section.data = data
                    return section
                }
                return state

            case let .setSegment(index, id):
                var state = state
                state.data = state.data.map { section -> AppState.Section in
                    var section = section
                    let data = section.data.map { dataType -> AppState.DataType in
                        switch dataType {
                        case let .segmentData(segmentData):
                            if segmentData.id == id {
                                var segmentData = segmentData
                                segmentData.selectedIndex = index

                                if section.value != "Second" {
                                    section.value = segmentData.segments[segmentData.selectedIndex]
                                }

                                return .segmentData(segmentData)
                            } else {
                                return dataType
                            }

                        case .headerData, .boolData:
                            return dataType
                        }
                    }
                    section.data = data
                    return section
                }
                state.data = state.data.map { section -> AppState.Section in
                    var section = section
                    let data = section.data.map { dataType -> AppState.DataType in
                        switch dataType {
                        case let .headerData(headerData):
                            var headerData = headerData
                            headerData.title = section.value
                            return .headerData(headerData)

                        case .segmentData, .boolData:
                            return dataType
                        }
                    }
                    section.data = data
                    return section
                }
                return state

            case .resetAll:
                var state = state
                state.shouldReset = true
                return state

            case .resetted:
                var state = state
                state.shouldReset = false
                return state
            }
        }
    }
}
