//
//  ReusableViewController.swift
//  ReusableViewControllers
//
//  Created by Dmitrii Coolerov on 13.07.2022.
//

import Foundation
import UIKit

protocol ReusableViewOutput: AnyObject {
    func decrement()
    func increment()
    func getValue() -> Int
}

final class ReusableViewController: UIViewController {

    private let output: ReusableViewOutput
    init(output: ReusableViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        setupDecrementButton()
        setupIncrementButton()
    }

    private func setupDecrementButton() {
        let decrementButton = UIButton()

        view.addSubview(decrementButton)
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        let decrementButtonContstraints = [
            decrementButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            decrementButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -20)
        ]
        decrementButtonContstraints.forEach { $0.isActive = true }

        decrementButton.setTitle("-", for: .normal)
        decrementButton.addTarget(self, action: #selector(decrement), for: .touchUpInside)
    }

    @IBAction private func decrement() {
        output.decrement()
    }

    private func setupIncrementButton() {
        let incrementButton = UIButton()

        view.addSubview(incrementButton)
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        let incrementButtonContstraints = [
            incrementButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            incrementButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20)
        ]
        incrementButtonContstraints.forEach { $0.isActive = true }

        incrementButton.setTitle("+", for: .normal)
        incrementButton.addTarget(self, action: #selector(increment), for: .touchUpInside)
    }

    @IBAction private func increment() {
        output.increment()
    }
}
