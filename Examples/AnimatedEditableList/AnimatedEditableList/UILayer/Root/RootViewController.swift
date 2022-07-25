//
//  RootViewController.swift
//  AnimatedEditableList
//
//  Created by Dmitrii Cooler on 20.07.2022.
//

import Foundation
import Highway
import UIKit

final class RootViewController: UISplitViewController {
    private let store: Store<RootFeature.State, RootFeature.Action>
    private let mainViewControllerFactory: () -> UIViewController
    private let detailsViewControllerFactory: () -> UIViewController

    init(
        store: Store<RootFeature.State, RootFeature.Action>,
        mainViewControllerFactory: @escaping () -> UIViewController,
        detailsViewControllerFactory: @escaping () -> UIViewController
    ) {
        self.store = store
        self.mainViewControllerFactory = mainViewControllerFactory
        self.detailsViewControllerFactory = detailsViewControllerFactory

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [mainViewControllerFactory(), detailsViewControllerFactory()]
    }
}
