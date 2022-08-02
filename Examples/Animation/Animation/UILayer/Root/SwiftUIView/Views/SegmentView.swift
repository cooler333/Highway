//
//  SegmentView.swift
//  Animation
//
//  Created by Dmitrii Coolerov on 02.08.2022.
//

import Highway
import SwiftUI

struct SegmentView: View {
    private var selection: Binding<String> {
        Binding(
            get: {
                data.segments[data.selectedIndex]
            },
            set: { value in
                store.dispatch(.setSegment(index: data.segments.firstIndex(of: value)!, id: data.id))
            }
        )
    }

    private let data: AppState.SegmentData
    private let store: Store<AppState, RootFeature.Action>

    @State private var disablesAnimations = true

    init(
        data: AppState.SegmentData,
        store: Store<AppState, RootFeature.Action>
    ) {
        self.data = data
        self.store = store
    }

    var body: some View {
        Picker("", selection: selection) {
            ForEach(data.segments) {
                Text($0)
            }
        }
        .labelsHidden()
        .pickerStyle(.segmented)
        .animation(.default) // not works
        .onAppear {
            DispatchQueue.main.async {
                if disablesAnimations != false {
                    disablesAnimations = false
                }
            }
        }
        .transaction { transaction in
            transaction.disablesAnimations = disablesAnimations
        }
    }
}
