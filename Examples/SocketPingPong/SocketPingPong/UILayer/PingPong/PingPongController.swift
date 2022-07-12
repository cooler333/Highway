//
//  PingPongViewController.swift
//  SocketPingPong
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import UIKit
import Highway

final class PingPongViewController: UIViewController {

    private let store: Store<AppState, PingPongFeature.Action>

    private var playButton: UIButton!

    init(store: Store<AppState, PingPongFeature.Action>) {
        self.store = store

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        setupPlayButton()

        render(state: store.state)
        store.subscribe { [weak self] state in
            self?.render(state: state)
        }
    }

    private func render(state: AppState) {
        switch state.playType {
        case .playing:
            playButton.setTitle("Pause", for: .normal)

        case .readyToPlay:
            playButton.setTitle("Pause", for: .normal)

        case .paused:
            playButton.setTitle("Play", for: .normal)
        }
    }

    private func setupPlayButton() {
        let playButton = UIButton(type: .system)
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        let playButtonContstraints = [
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        playButtonContstraints.forEach { $0.isActive = true }
        self.playButton = playButton

        playButton.addTarget(self, action: #selector(playButtonDidTap), for: .touchUpInside)
    }

    @IBAction private func playButtonDidTap() {
        switch store.state.playType {
        case .playing:
            store.dispatch(.pause)
        case .readyToPlay:
            store.dispatch(.pause)
        case .paused:
            store.dispatch(.play)
        }
    }

}
