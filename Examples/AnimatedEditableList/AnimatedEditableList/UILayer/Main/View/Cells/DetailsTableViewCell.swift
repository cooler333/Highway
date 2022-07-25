//
//  DetailsTableViewCell.swift
//  AnimatedEditableList
//
//  Created by Dmitrii Cooler on 18.07.2022.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    private var titleLabel: UILabel!

    private var leftButton: UIButton!
    private var leftButtonAction: (() -> Void)!

    private var centerButton: UIButton!
    private var centerButtonAction: (() -> Void)!

    private var rightButton: UIButton!
    private var rightButtonAction: (() -> Void)!

    // swiftlint:disable:next function_body_length
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ]
        stackViewConstraints.forEach { $0.isActive = true }
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally

        let titleLabel = UILabel()
        self.titleLabel = titleLabel
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.numberOfLines = 0
        stackView.addArrangedSubview(titleLabel)

        let buttonStackView = UIStackView()
        buttonStackView.backgroundColor = .secondarySystemBackground
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillProportionally

        let leftButton = UIButton(type: .system)
        leftButton.addTarget(self, action: #selector(leftButtonDidTap), for: .touchUpInside)
        leftButton.setTitle("Remove", for: .normal)
        leftButton.setTitleColor(.red, for: .normal)
        self.leftButton = leftButton
        buttonStackView.addArrangedSubview(leftButton)

        let centerButton = UIButton(type: .system)
        centerButton.addTarget(self, action: #selector(centerButtonDidTap), for: .touchUpInside)
        centerButton.setTitle("Update", for: .normal)
        self.centerButton = centerButton
        buttonStackView.addArrangedSubview(centerButton)

        let rightButton = UIButton(type: .system)
        rightButton.addTarget(self, action: #selector(rightButtonDidTap), for: .touchUpInside)
        rightButton.setTitle("Insert", for: .normal)
        self.rightButton = rightButton
        buttonStackView.addArrangedSubview(rightButton)

        stackView.addArrangedSubview(buttonStackView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        title: String,
        deleteButtonAction: @escaping () -> Void,
        updateButtonAction: @escaping () -> Void,
        insertButtonAction: @escaping () -> Void
    ) {
        titleLabel.text = title

        leftButtonAction = deleteButtonAction
        centerButtonAction = updateButtonAction
        rightButtonAction = insertButtonAction
    }

    @IBAction
    private func leftButtonDidTap() {
        leftButtonAction()
    }

    @IBAction
    private func centerButtonDidTap() {
        centerButtonAction()
    }

    @IBAction
    private func rightButtonDidTap() {
        rightButtonAction()
    }
}
