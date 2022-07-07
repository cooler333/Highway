//
//  DetailsViewController.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 03.07.2022.
//

import Combine
import Highway
import UIKit

class DetailsViewController: UIViewController {

    private let store: Store<MailListState.List, String>

    private var cancellable = Set<AnyCancellable>()
    private let uiSubject = PassthroughSubject<MailListState.List, Never>()

    private var label: UILabel!

    init(
        store: Store<MailListState.List, String>
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

        view.backgroundColor = .cyan

        let label = UILabel(frame: .zero)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        label.numberOfLines = 0
        self.label = label

        store.subscribe { [weak self] state in
            guard let self = self else { return }
            self.uiSubject.send(state)
        }

        uiSubject.throttle(
            for: 0.25,
            scheduler: DispatchQueue.main,
            latest: true
        )
        .sink { state in
            self.render(state: state)
        }
        .store(in: &cancellable)
    }

    private func render(state: MailListState.List) {
        label.text = state.selectedMailID
    }
}
