//
//  RootView.swift
//  Animation
//
//  Created by Dmitrii Coolerov on 01.08.2022.
//

import Highway
import SwiftUI

struct RootView: View {
    private let store: Store<AppState, RootFeature.Action>

    @State var data: [AppState.Section] = []

    init(store: Store<AppState, RootFeature.Action>) {
        self.store = store
    }

    var body: some View {
        List {
            ForEach(data) { section in
                Section(header: Text(section.value)) {
                    ForEach(section.data) { item in
                        switch item {
                        case let .boolData(boolData):
                            BoolView(data: boolData, store: store)

                        case let .headerData(headerData):
                            HeaderView(text: headerData.title)

                        case let .segmentData(segmentData):
                            SegmentView(data: segmentData, store: store)
                        }
                    }
                }
            }
        }.onAppear() {
            self.data = store.state.data
            store.subscribe { state in
                DispatchQueue.main.async {
                    self.data = store.state.data
                }
            }
        }
    }
}

struct BoolView: View {
    @State var isOn: Bool

    private let data: AppState.BoolData
    private let store: Store<AppState, RootFeature.Action>

    init(
        data: AppState.BoolData,
        store: Store<AppState, RootFeature.Action>
    ) {
        self.data = data
        isOn = data.isOn
        self.store = store
    }

    var body: some View {
        Toggle("", isOn: $isOn)
            .labelsHidden()
            .toggleStyle(.switch)
            .onChangeWrapper(
                value: isOn,
                perform: { (value) in
                    if value {
                        store.dispatch(.setOn(id: data.id))
                    } else {
                        store.dispatch(.setOff(id: data.id))
                    }
                }
            )
    }
}

struct HeaderView: View {
    let text: String

    var body: some View {
        Text(text)
    }
}

struct SegmentView: View {
    @State private var selection: String

    private let data: AppState.SegmentData
    private let store: Store<AppState, RootFeature.Action>

    init(
        data: AppState.SegmentData,
        store: Store<AppState, RootFeature.Action>
    ) {
        self.data = data
        selection = data.segments[data.selectedIndex]
        self.store = store
    }

    var body: some View {
        Picker("", selection: $selection) {
            ForEach(data.segments) {
                Text($0)
            }
        }
        .onChangeWrapper(
            value: selection,
            perform: { (value) in
                store.dispatch(.setSegment(index: data.segments.firstIndex(of: selection)!, id: data.id))
            }
        )
        .labelsHidden()
        .pickerStyle(.segmented)
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                reducer: .init({ state, action in
                    return state
                }),
                state: .init(
                    data: [
                        .init(
                            id: "Foo",
                            value: "Foo",
                            data: [
                                .headerData(.init(id: "foo", title: "foo")),
                                .segmentData(.init(id: "bar", segments: ["foo", "bar"], selectedIndex: 0, state: .normal)),
                                .boolData(.init(id: "baz", isOn: true, state: .normal))
                            ]
                        )
                    ]
                )
            )
        )
    }
}
