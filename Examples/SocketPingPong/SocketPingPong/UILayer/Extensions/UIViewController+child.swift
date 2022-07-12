//
//  UIViewController+child.swift
//  SocketPingPong
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func addChild(_ child: UIViewController, to view: UIView) {
        let childView = child.view!

        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        let childViewConstraints = [
            childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childView.topAnchor.constraint(equalTo: view.topAnchor),
            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        childViewConstraints.forEach{ $0.isActive = true }

        addChild(child)
        child.didMove(toParent: self)
    }

    func removeChild(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.removeFromParent()
        child.view.removeFromSuperview()
    }
}
