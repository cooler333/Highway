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

    private let topViewControllerFactory: () -> UIViewController
    private let bottomViewControllerFactory: () -> UIViewController

    private var label: UILabel!

    init(
        store: Store<AppState, RootAction>,
        topViewControllerFactory: @escaping () -> UIViewController,
        bottomViewControllerFactory: @escaping () -> UIViewController
    ) {
        self.store = store

        self.topViewControllerFactory = topViewControllerFactory
        self.bottomViewControllerFactory = bottomViewControllerFactory

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
        setupLabel()

        render(state: store.state)
        store.subscribe { [weak self] state in
            self?.render(state: state)
        }
    }

    private func render(state: AppState) {
        label.text = "\(state.count)"
    }

    private func embedMainViewController() {
        let topContainerView = UIView()
        view.addSubview(topContainerView)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        let topContainerViewConstraints = [
            topContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainerView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -30)
        ]
        topContainerViewConstraints.forEach{ $0.isActive = true }

        let topViewController = topViewControllerFactory()
        addChild(topViewController, to: topContainerView)
    }

    private func embedCounterViewController() {
        let bottomContainerView = UIView()
        view.addSubview(bottomContainerView)
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        let bottomContainerViewConstraints = [
            bottomContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomContainerView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        bottomContainerViewConstraints.forEach{ $0.isActive = true }

        let bottomViewController = bottomViewControllerFactory()
        addChild(bottomViewController, to: bottomContainerView)
    }

    private func setupLabel() {
        let label = UILabel()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelConstraints = [
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        labelConstraints.forEach { $0.isActive = true }

        self.label = label
    }
}
