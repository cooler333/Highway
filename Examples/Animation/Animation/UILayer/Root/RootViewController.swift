//
//  RootViewController.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Highway
import UIKit

class RootViewController: UIViewController {
    private let store: Store<AppState, RootAction>

    private var stackView: UIStackView!
    private var switches: [UISwitch] = []

    init(
        store: Store<AppState, RootAction>
    ) {
        self.store = store

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
        addSwitch()
        addSwitch()
        addSwitch()
        addSwitch()
        addSwitch()
        addSwitch()
        addReset()

        render(state: store.state)
        store.subscribe { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                self?.render(state: state)
            }
        }
    }

    private func render(state: AppState) {
        if state.shouldReset {
            switches.forEach { uiswitch in
                playResetSizeAnimation(uiswitch: uiswitch)
            }
            store.dispatch(.resetted)
        } else {
            switches.forEach { uiswitch in
                if uiswitch.isOn != state.isOn {
                    uiswitch.setOn(state.isOn, animated: true)

                    if state.isOn {
                        playSwitchOnAnimation(uiswitch: uiswitch)
                    } else {
                        playSwitchOffAnimation(uiswitch: uiswitch)
                    }
                } else {
                    playResetSizeAnimation(uiswitch: uiswitch)
                }
            }
        }
    }

    private func playSwitchOnAnimation(uiswitch: UISwitch) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.allowUserInteraction],
            animations: {
                uiswitch.transform = CGAffineTransform(scaleX: 2, y: 2)
            }, completion: { completed in
                if !completed {
                    uiswitch.transform = .identity
                }
            }
        )
    }

    private func playSwitchOffAnimation(uiswitch: UISwitch) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.allowUserInteraction],
            animations: {
                uiswitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { completed in
                if !completed {
                    uiswitch.transform = CGAffineTransform.identity
                }
            }
        )
    }

    private func playResetSizeAnimation(uiswitch: UISwitch) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.allowUserInteraction],
            animations: {
                uiswitch.transform = .identity
            }, completion: { completed in
                if !completed {
                    uiswitch.transform = CGAffineTransform.identity
                }
            }
        )
    }

    private func createStackView() {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        stackViewConstraints.forEach { $0.isActive = true }

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.alignment = .center

        self.stackView = stackView
    }

    private func addSwitch() {
        let uiswitch = UISwitch()
        stackView.addArrangedSubview(uiswitch)
        uiswitch.addTarget(self, action: #selector(switchDidTap), for: .valueChanged)
        switches.append(uiswitch)
    }

    @IBAction
    private func switchDidTap(_ uiswitch: UISwitch) {
        if uiswitch.isOn {
            store.dispatch(.setOn)
        } else {
            store.dispatch(.setOff)
        }
    }

    private func addReset() {
        let resetButton = UIButton(type: .system)
        stackView.addArrangedSubview(resetButton)
        resetButton.addTarget(self, action: #selector(resetButtonDidTap), for: .touchUpInside)
        resetButton.setTitle("Reset", for: .normal)
    }

    @IBAction
    private func resetButtonDidTap() {
        store.dispatch(.reset)
    }
}
