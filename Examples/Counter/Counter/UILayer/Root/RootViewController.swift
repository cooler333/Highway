//
//  RootViewController.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import UIKit
import Highway

class RootViewController: UIViewController {

    private let store: Store<AppState, RootAction>

    private let mainViewControllerFactory: () -> UIViewController
    private let counterViewControllerFactory: () -> UIViewController

    init(
        store: Store<AppState, RootAction>,
        mainViewControllerFactory: @escaping () -> UIViewController,
        counterViewControllerFactory: @escaping () -> UIViewController
    ) {
        self.store = store

        self.mainViewControllerFactory = mainViewControllerFactory
        self.counterViewControllerFactory = counterViewControllerFactory

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        embedMainViewController()
        embedCounterViewController()

        store.subscribe { state in
            print(state)
        }
    }

    private func embedMainViewController() {
        let mainContainerView = UIView()
        view.addSubview(mainContainerView)
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        let mainContainerViewConstraints = [
            mainContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        mainContainerViewConstraints.forEach{ $0.isActive = true }

        let mainViewController = mainViewControllerFactory()
        addChild(mainViewController, to: mainContainerView)
    }

    private func embedCounterViewController() {
        let counterContainerView = UIView()
        view.addSubview(counterContainerView)
        counterContainerView.translatesAutoresizingMaskIntoConstraints = false
        let counterContainerViewConstraints = [
            counterContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            counterContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            counterContainerView.topAnchor.constraint(equalTo: view.centerYAnchor),
            counterContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        counterContainerViewConstraints.forEach{ $0.isActive = true }

        let counterViewController = counterViewControllerFactory()
        addChild(counterViewController, to: counterContainerView)
    }
}
