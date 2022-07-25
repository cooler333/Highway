//
//  MainViewController.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Combine
import Foundation
import Highway
import SwiftUI

struct MainView: View {
    private let store: Store<AppState, MainFeature.Action>

    @State var countString: String = ""

    init(
        store: Store<AppState, MainFeature.Action>
    ) {
        self.store = store
    }

    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
            VStack {
                Text(countString)
                    .padding()
                    .multilineTextAlignment(.center)
                Button(action: {
                    store.dispatch(.increment)
                }, label: {
                    Text("Increment")
                })
                .padding()
                Button(action: {
                    store.dispatch(.decrement)
                }, label: {
                    Text("Decrement")
                })
                .padding()
            }
        }
        .onAppear {
            configure()
            store.subscribe { _ in
                DispatchQueue.main.async {
                    configure()
                }
            }
        }
    }

    private func configure() {
        var text = "\(store.state.count)"
        if store.state.isSaving == true {
            text += "\nSaving"
        }
        countString = text
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let view = MainView(
            store: .init(
                reducer: .init { state, _ in
                    state
                },
                state: .init(
                    count: 12_313_112_312,
                    isSaving: true,
                    saved: true
                )
            )
        )
        return view
    }
}
