//
//  UITableView+Reuse.swift
//  AnimatedEditableList
//
//  Created by Dmitrii Cooler on 18.07.2022.
//

import Foundation
import UIKit

extension UITableView {
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }

    open func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type) -> T {
        dequeueReusableCell(withIdentifier: String(describing: cellClass)) as! T
    }
}
