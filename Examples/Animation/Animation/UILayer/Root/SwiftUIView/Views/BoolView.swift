//
//  BoolView.swift
//  Animation
//
//  Created by Dmitrii Coolerov on 02.08.2022.
//

import Highway
import SwiftUI

struct BoolView: View {
    private var isOn: Binding<Bool> {
        Binding(
            get: {
                data.isOn
            },
            set: { value in
                if value {
                    store.dispatch(.setOn(id: data.id))
                } else {
                    store.dispatch(.setOff(id: data.id))
                }
            }
        )
    }

    private let data: AppState.BoolData
    private let store: Store<AppState, RootFeature.Action>

    @State private var disablesAnimations = true

    init(
        data: AppState.BoolData,
        store: Store<AppState, RootFeature.Action>
    ) {
        self.data = data
        self.store = store
    }

    var body: some View {
        Toggle("", isOn: isOn)
            .labelsHidden()
            .animation(.default)
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
