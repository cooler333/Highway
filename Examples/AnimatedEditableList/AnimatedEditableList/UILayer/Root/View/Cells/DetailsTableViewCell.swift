//
//  DetailsTableViewCell.swift
//  AnimatedEditableList
//
//  Created by Dmitrii Cooler on 18.07.2022.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    func configure(details: String) {
        textLabel?.font = .preferredFont(forTextStyle: .subheadline)
        textLabel?.numberOfLines = 0
        textLabel?.text = details
    }
}
