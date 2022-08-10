//
//  SwitchTableViewCell.swift
//  Animation
//
//  Created by Dmitrii Cooler on 25.07.2022.
//

import UIKit

final class SwitchTableViewCell: UITableViewCell {

    private var uiSwitch: UISwitch!
    private var switchDidChange: ((Bool) -> Void)!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(uiSwitch)

        let uiSwitchContstraints: [NSLayoutConstraint] = [
            uiSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            uiSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            uiSwitch.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ]
        uiSwitchContstraints.forEach { $0.isActive = true }

        uiSwitch.addTarget(self, action: #selector(switchDidTap), for: .valueChanged)
        self.uiSwitch = uiSwitch
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction
    private func switchDidTap(_ uiSwitch: UISwitch) {
        switchDidChange(uiSwitch.isOn)
    }

    func configure(isOn: Bool, switchDidChange: @escaping (Bool) -> Void) {
        if #available(iOS 15, *) {
            if uiSwitch.isOn != isOn {
                uiSwitch.setOn(isOn, animated: true)
                if isOn {
                    playSwitchOnAnimation(uiSwitch: self.uiSwitch)
                } else {
                    playSwitchOffAnimation(uiSwitch: self.uiSwitch)
                }
            }
        } else {
            uiSwitch.setOn(!isOn, animated: false)
            if !isOn {
                uiSwitch.transform = CGAffineTransform(scaleX: 2, y: 2)
            } else {
                uiSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }

            DispatchQueue.main.async {
                self.uiSwitch.setOn(isOn, animated: true)
                if isOn {
                    self.playSwitchOnAnimation(uiSwitch: self.uiSwitch)
                } else {
                    self.playSwitchOffAnimation(uiSwitch: self.uiSwitch)
                }
            }
        }
        self.switchDidChange = switchDidChange
    }

    private func playSwitchOnAnimation(uiSwitch: UISwitch) {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.allowUserInteraction],
            animations: {
                uiSwitch.transform = CGAffineTransform(scaleX: 2, y: 2)
            }, completion: { completed in
                if !completed {
                    uiSwitch.transform = .identity
                }
            }
        )
    }

    private func playSwitchOffAnimation(uiSwitch: UISwitch) {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.allowUserInteraction],
            animations: {
                uiSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { completed in
                if !completed {
                    uiSwitch.transform = CGAffineTransform.identity
                }
            }
        )
    }
}
