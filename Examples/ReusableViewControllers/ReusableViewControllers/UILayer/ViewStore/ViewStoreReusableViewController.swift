//
//  ViewStoreReusableViewController.swift
//  ReusableViewControllers
//
//  Created by Dmitrii Coolerov on 13.07.2022.
//

import Foundation
import Highway
import UIKit

final class ViewStoreReusableViewController: UIViewController {
    struct State: Equatable {
        let value: String
    }

    enum Action {
        case increment
        case decrement
    }

    private let viewStore: ViewStore<State, Action>

    private var currentValueLabel: UILabel!

    init(viewStore: ViewStore<State, Action>) {
        self.viewStore = viewStore

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple

        setupDecrementButton()
        setupIncrementButton()
        setupCurrentValueLabel()

        render(state: viewStore.state)
        viewStore.subscribe { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                self?.render(state: state)
            }
        }
    }

    private func render(state: State) {
        self.currentValueLabel.text = state.value
    }

    private func setupDecrementButton() {
        let decrementButton = UIButton()

        view.addSubview(decrementButton)
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        let decrementButtonContstraints = [
            decrementButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            decrementButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
        ]
        decrementButtonContstraints.forEach { $0.isActive = true }

        decrementButton.setTitle("-", for: .normal)
        decrementButton.addTarget(self, action: #selector(decrement), for: .touchUpInside)
    }

    @IBAction private func decrement() {
        viewStore.dispatch(.decrement)
    }

    private func setupIncrementButton() {
        let incrementButton = UIButton()

        view.addSubview(incrementButton)
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        let incrementButtonContstraints = [
            incrementButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            incrementButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
        ]
        incrementButtonContstraints.forEach { $0.isActive = true }

        incrementButton.setTitle("+", for: .normal)
        incrementButton.addTarget(self, action: #selector(increment), for: .touchUpInside)
    }

    @IBAction private func increment() {
        viewStore.dispatch(.increment)
    }

    private func setupCurrentValueLabel() {
        let currentValueLabel = UILabel()
        view.addSubview(currentValueLabel)
        currentValueLabel.translatesAutoresizingMaskIntoConstraints = false
        let currentValueLabelContstraints = [
            currentValueLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            currentValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        currentValueLabelContstraints.forEach { $0.isActive = true }

        self.currentValueLabel = currentValueLabel

        currentValueLabel.textColor = .white
    }
}
