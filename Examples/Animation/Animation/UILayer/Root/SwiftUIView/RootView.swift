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
        }.onAppear {
            self.data = store.state.data
            store.subscribe { state in
                DispatchQueue.main.async {
                    self.data = store.state.data
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                reducer: .init { state, action in
                    state
                },
                state: .init(
                    data: [
                        .init(
                            id: "Foo",
                            value: "Foo",
                            data: [
                                .headerData(.init(id: "foo", title: "foo")),
                                .segmentData(.init(
                                    id: "bar",
                                    segments: ["foo", "bar"],
                                    selectedIndex: 0,
                                    state: .normal
                                )),
                                .boolData(.init(id: "baz", isOn: true, state: .normal)),
                            ]
                        ),
                    ]
                )
            )
        )
    }
}
