//
//  ResultViewController.swift
//  SocketPingPong
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import Highway
import UIKit

final class ResultViewController: UIViewController {
    private let store: Store<AppState, ResultFeature.Action>

    private var statusLabel: UILabel!

    init(store: Store<AppState, ResultFeature.Action>) {
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

        setupStatusLabel()

        render(state: store.state)
        store.subscribe { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                self?.render(state: state)
            }
        }
    }

    private func render(state: AppState) {
        statusLabel.text = "\(state.sideType)\n\n\(state.playType)"
    }

    private func setupStatusLabel() {
        let statusLabel = UILabel()
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        let statusLabelContstraints = [
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        statusLabelContstraints.forEach { $0.isActive = true }
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        self.statusLabel = statusLabel
    }
}
