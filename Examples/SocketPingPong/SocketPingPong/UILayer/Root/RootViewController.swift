//
//  RootViewController.swift
//  SocketPingPong
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Highway
import UIKit

class RootViewController: UIViewController {
    private let store: Store<AppState, RootAction>

    private let resultViewControllerFactory: () -> UIViewController
    private let pingPongViewControllerFactory: () -> UIViewController

    init(
        store: Store<AppState, RootAction>,
        resultViewControllerFactory: @escaping () -> UIViewController,
        pingPongViewControllerFactory: @escaping () -> UIViewController
    ) {
        self.store = store

        self.resultViewControllerFactory = resultViewControllerFactory
        self.pingPongViewControllerFactory = pingPongViewControllerFactory

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        embedResultViewController()
        embedPingPongViewController()

        store.subscribe { state in
            print(state)
        }
    }

    private func embedResultViewController() {
        let resultContainerView = UIView()
        view.addSubview(resultContainerView)
        resultContainerView.translatesAutoresizingMaskIntoConstraints = false
        let resultContainerViewConstraints = [
            resultContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            resultContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            resultContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultContainerView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
        ]
        resultContainerViewConstraints.forEach { $0.isActive = true }

        let resultViewController = resultViewControllerFactory()
        addChild(resultViewController, to: resultContainerView)
    }

    private func embedPingPongViewController() {
        let pingPongContainerView = UIView()
        view.addSubview(pingPongContainerView)
        pingPongContainerView.translatesAutoresizingMaskIntoConstraints = false
        let counterContainerViewConstraints = [
            pingPongContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pingPongContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pingPongContainerView.topAnchor.constraint(equalTo: view.centerYAnchor),
            pingPongContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        counterContainerViewConstraints.forEach { $0.isActive = true }

        let pingPongViewController = pingPongViewControllerFactory()
        addChild(pingPongViewController, to: pingPongContainerView)
    }
}
