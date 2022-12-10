//
//  RootViewController.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Highway
import UIKit

final class RootViewController: UIViewController {
    private let store: Store<AppState, RootFeature.Action>

    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<ContentSectionIdentifier, ContentIdentifier>!

    init(
        store: Store<AppState, RootFeature.Action>
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

        createTableView()
        createDataSource()

        render(state: store.state)
        store.subscribe { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                self?.render(state: state)
            }
        }
    }

    private func render(state: AppState) {
        var snapshot = NSDiffableDataSourceSnapshot<ContentSectionIdentifier, ContentIdentifier>()
        state.data.forEach { section in
            let sectionItem = ContentSectionIdentifier(id: section.id, contentHashValue: section.contentHashValue)
            snapshot.appendSections([sectionItem])

            let items = section.data.map { dataType -> ContentIdentifier in
                ContentIdentifier(id: dataType.id, contentHashValue: dataType.contentHashValue)
            }
            snapshot.appendItems(items)
        }

        snapshot = reconfigure(previousSnapshot: dataSource.snapshot(), newSnapshot: snapshot)

        dataSource.apply(snapshot)
    }

    private func createTableView() {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewConstraints = [
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        tableViewConstraints.forEach { $0.isActive = true }

        self.tableView = tableView

        tableView.delegate = self

        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchTableViewCell")
        tableView.register(SegmentedTableViewCell.self, forCellReuseIdentifier: "SegmentedTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }

    private func createDataSource() {
        let dataSource = UITableViewDiffableDataSource<ContentSectionIdentifier, ContentIdentifier>(
            tableView: tableView,
            cellProvider: { [unowned self] tableView, indexPath, itemIdentifier in
                self.getCell(for: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
            }
        )
        dataSource.defaultRowAnimation = .right

        self.dataSource = dataSource
    }

    private func getCell(
        for tableView: UITableView,
        indexPath: IndexPath,
        itemIdentifier: ContentIdentifier
    ) -> UITableViewCell {
        guard let sectionItem = dataSource.snapshot().sectionIdentifier(containingItem: itemIdentifier) else {
            fatalError("unexpeced state")
        }

        let data = store.state.data

        guard let section = data.first(where: { $0.id == sectionItem.id }) else {
            fatalError("unexpected state")
        }

        guard let item = section.data.first(where: { $0.id == itemIdentifier.id }) else {
            fatalError("unexpected state")
        }

        switch item {
        case let .headerData(headerData):
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = headerData.title
            return cell

        case let .boolData(boolData):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SwitchTableViewCell",
                for: indexPath
                // swiftlint:disable:next force_cast
            ) as! SwitchTableViewCell
            let id = boolData.id
            cell.configure(isOn: boolData.isOn, switchDidChange: { [weak self, id] isOn in
                guard let self = self else { return }
                if isOn {
                    self.store.dispatch(.setOn(id: id))
                } else {
                    self.store.dispatch(.setOff(id: id))
                }
            })
            return cell

        case let .segmentData(segmentData):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SegmentedTableViewCell",
                for: indexPath
                // swiftlint:disable:next force_cast
            ) as! SegmentedTableViewCell
            let id = segmentData.id
            cell.configure(
                segments: segmentData.segments,
                selectedIndex: segmentData.selectedIndex,
                segmentDidChange: { [weak self, id] selectedIndex in
                    self?.store.dispatch(.setSegment(index: selectedIndex, id: id))
                }
            )
            return cell
        }
    }
}

extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[section]
        guard let section = store.state.data.first(where: { $0.id == sectionIdentifier.id }) else {
            fatalError("unexpected state")
        }

        let header: UITableViewHeaderFooterView
        if let tempHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "title") {
            header = tempHeader
        } else {
            header = UITableViewHeaderFooterView(reuseIdentifier: "title")
        }
        header.textLabel?.text = section.value
        return header
    }
}

private extension RootViewController {
    // swiftlint:disable:next line_length
    /// [apple reference example](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/updating_collection_views_using_diffable_data_sources)
    func reconfigure(
        previousSnapshot: NSDiffableDataSourceSnapshot<ContentSectionIdentifier, ContentIdentifier>,
        newSnapshot: NSDiffableDataSourceSnapshot<ContentSectionIdentifier, ContentIdentifier>
    ) -> NSDiffableDataSourceSnapshot<ContentSectionIdentifier, ContentIdentifier> {
        var newSnapshot = newSnapshot

        newSnapshot.sectionIdentifiers.forEach { contentSectionIdentifier in
            // find section in data
            if previousSnapshot.sectionIdentifiers.contains(contentSectionIdentifier) {
                // update previous section
                guard let previousSectionIdentifier = previousSnapshot.sectionIdentifiers.first(
                    where: { $0.id == contentSectionIdentifier.id }
                ) else {
                    fatalError("unexpected state")
                }
                if contentSectionIdentifier.contentHashValue != previousSectionIdentifier.contentHashValue {
                    // this is not work
                    // whole section is reloaded instead of just header
                    // newSnapshot.reloadSections([contentSectionIdentifier])

                    // or...
                    // thanks apple :)
                    // do not do this code in production
                    guard let index = dataSource.snapshot().indexOfSection(contentSectionIdentifier) else {
                        fatalError("unexpected state")
                    }
                    guard let header = tableView.headerView(forSection: index) else {
                        fatalError("unexpected state")
                    }

                    guard let section = store.state.data.first(where: { $0.id == contentSectionIdentifier.id }) else {
                        fatalError("unexpected state")
                    }

                    header.textLabel?.text = section.value
                }

                newSnapshot.itemIdentifiers(inSection: contentSectionIdentifier).forEach { contentIdentifier in
                    if previousSnapshot.itemIdentifiers(
                        inSection: contentSectionIdentifier
                    ).contains(contentIdentifier) {
                        guard let previousContentIdentifier = previousSnapshot.itemIdentifiers(
                            inSection: contentSectionIdentifier
                        ).first(where: { $0.id == contentIdentifier.id }) else {
                            fatalError("unexpected state")
                        }
                        if contentIdentifier.contentHashValue != previousContentIdentifier.contentHashValue {
                            if #available(iOS 15.0, *) {
                                newSnapshot.reconfigureItems([contentIdentifier])
                            } else {
                                newSnapshot.reloadItems([contentIdentifier])
                            }
                        }
                    }
                }
            } else {
                // new section, no need to reconfigure
            }
        }
        return newSnapshot
    }
}
