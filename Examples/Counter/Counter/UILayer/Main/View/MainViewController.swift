//
//  MainViewController.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Combine
import Foundation
import UIKit
import Highway

final class MainViewController: UIViewController {

    private let store: Store<AppState, MainFeature.Action>

    private var countLabel: UILabel!

    private let uiPublisher = PassthroughSubject<AppState, Never>()
    private var cancellable = Set<AnyCancellable>()

    init(store: Store<AppState, MainFeature.Action>) {
        self.store = store

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground

        setupCountLabel()

        render(state: store.state)

        store.subscribe(listener: { [weak self] state in
            guard let self = self else { return }
            self.uiPublisher.send(state)
        })

        uiPublisher
            .receive(on: DispatchQueue.main)
            .sink { state in
                self.render(state: state)
            }
            .store(in: &cancellable)
    }

    private func setupCountLabel() {
        let countLabel = UILabel()
        view.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        let countLabelContstraints = [
            countLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        countLabelContstraints.forEach { $0.isActive = true }
        countLabel.numberOfLines = 0
        countLabel.textAlignment = .center

        self.countLabel = countLabel
    }

    private func render(state: AppState) {
        var text = "\(state.count)"
        if state.isSaving == true {
            text += "\nSaving"
        }
        countLabel.text = text
    }
}
