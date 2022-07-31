//
//  SegmentedTableViewCell.swift
//  Animation
//
//  Created by Dmitrii Cooler on 25.07.2022.
//

import UIKit

class SegmentedTableViewCell: UITableViewCell {

    private var segmentedControl: UISegmentedControl!
    private var segmentDidChange: ((Int) -> Void)!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(segmentedControl)

        let segmentedControlContstraints: [NSLayoutConstraint] = [
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ]
        segmentedControlContstraints.forEach { $0.isActive = true }

        segmentedControl.addTarget(self, action: #selector(segmentedControlDidTap), for: .valueChanged)
        self.segmentedControl = segmentedControl
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction
    private func segmentedControlDidTap(_ segmentedControl: UISegmentedControl) {
        segmentDidChange(segmentedControl.selectedSegmentIndex)
    }

    func configure(
        segments: [String],
        selectedIndex: Int,
        segmentDidChange: @escaping (Int) -> Void
    ) {
        segmentedControl.removeAllSegments()
        segments.reversed().forEach { segment in
            segmentedControl.insertSegment(withTitle: segment, at: 0, animated: false)
        }
        segmentedControl.selectedSegmentIndex = selectedIndex
        self.segmentDidChange = segmentDidChange
    }
}

