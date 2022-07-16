//
//  CounterViewController.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import UIKit
import Highway

final class CounterViewController: UIViewController {

    private let store: Store<AppState, CounterFeature.Action>

    private var stepper: UIStepper!

    init(store: Store<AppState, CounterFeature.Action>) {
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

        setupStepper()
        setupSaveButton()

        render(state: store.state)
        store.subscribe { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                self?.render(state: state)
            }
        }
    }

    private func render(state: AppState) {
        stepper.value = Double(state.count)
    }

    private func setupStepper() {
        let stepper = UIStepper()
        stepper.wraps = false
        stepper.minimumValue = -.greatestFiniteMagnitude
        stepper.maximumValue = .greatestFiniteMagnitude

        view.addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        let stepperContstraints = [
            stepper.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stepper.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        stepperContstraints.forEach { $0.isActive = true }

        stepper.addTarget(self, action: #selector(stepperDidChange), for: .valueChanged)

        self.stepper = stepper
    }

    @IBAction private func stepperDidChange(_ sender: UIStepper) {
        let value = Int(sender.value)
        if value < store.state.count {
            store.dispatch(.decrement)
        } else if value > store.state.count {
            store.dispatch(.increment)
        }
    }

    private func setupSaveButton() {
        let saveButton = UIButton(type: .system)
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let saveButtonContstraints = [
            saveButton.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 10),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        saveButtonContstraints.forEach { $0.isActive = true }

        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
    }

    @IBAction private func saveButtonDidTap() {
        store.dispatch(.save)
    }

}
