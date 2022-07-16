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

    private var stackView: UIStackView!

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

        createStackView()
        embedMainViewController()
        embedCounterViewController()

        store.subscribe { state in
            print(state)
        }
    }

    private func createStackView() {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        stackViewConstraints.forEach{ $0.isActive = true }

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30

        self.stackView = stackView
    }

    private func embedMainViewController() {
        let mainContainerView = UIView()
        stackView.addArrangedSubview(mainContainerView)
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        let mainContainerViewConstraints = [
            mainContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ]
        mainContainerViewConstraints.forEach{ $0.isActive = true }

        let mainViewController = mainViewControllerFactory()
        addChild(mainViewController, to: mainContainerView)
    }

    private func embedCounterViewController() {
        let counterContainerView = UIView()
        stackView.addArrangedSubview(counterContainerView)
        counterContainerView.translatesAutoresizingMaskIntoConstraints = false
        let counterContainerViewConstraints = [
            counterContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ]
        counterContainerViewConstraints.forEach{ $0.isActive = true }

        let counterViewController = counterViewControllerFactory()
        addChild(counterViewController, to: counterContainerView)
    }
}
