//
//  ImageTableViewCell.swift
//  AnimatedEditableList
//
//  Created by Dmitrii Cooler on 18.07.2022.
//

import Kingfisher
import UIKit

class ImageTableViewCell: UITableViewCell {

    private var remoteImageView: UIImageView!
    private var remoteImageViewHeightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        selectionStyle = .none
        
        let remoteImageView = UIImageView(frame: .zero)
        remoteImageView.translatesAutoresizingMaskIntoConstraints = false
        remoteImageView.contentMode = .scaleAspectFit
        contentView.addSubview(remoteImageView)
        
        let bottomContraint = remoteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomContraint.priority = .defaultHigh
        let remoteImageViewConstraints = [
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            remoteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            remoteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bottomContraint
        ]
        remoteImageViewConstraints.forEach{ $0.isActive = true }

        remoteImageView.clipsToBounds = true
        
        remoteImageViewHeightConstraint = remoteImageView.heightAnchor.constraint(equalToConstant: 44)
        remoteImageViewHeightConstraint.isActive = true

        self.remoteImageView = remoteImageView
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageURL: URL) {
        remoteImageViewHeightConstraint.constant = 253 * contentView.frame.width / 600
        remoteImageView.kf.setImage(with: imageURL)
    }
}
