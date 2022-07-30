//
//  RootViewController.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Highway
import UIKit

protocol ContentHashable {
    func contentHash(into hasher: inout Hasher)
}

class RootViewController: UIViewController {
    enum ItemType: Hashable, ContentHashable {
        case switchItem(SwitchItem)
        case segmentItem(SegmentItem)

        func hash(into hasher: inout Hasher) {
            switch self {
            case let .switchItem(item):
                item.hash(into: &hasher)

            case let .segmentItem(item):
                item.hash(into: &hasher)
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (let .switchItem(lhsItem), let .switchItem(rhsItem)):
                return lhsItem == rhsItem

            case (let .segmentItem(lhsItem), let .segmentItem(rhsItem)):
                return lhsItem == rhsItem

            default:
                return false
            }
        }

        func contentHash(into hasher: inout Hasher) {
            switch self {
            case let .switchItem(item):
                item.contentHash(into: &hasher)

            case let .segmentItem(item):
                item.contentHash(into: &hasher)
            }
        }
    }

    struct SwitchItem: Hashable, ContentHashable {
        enum Size {
            case normal
            case small
            case large
        }

        let id: String
        let isOn: Bool
        let size: Size

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }

        func contentHash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(isOn)
            hasher.combine(size)
        }
    }

    struct SegmentItem: Hashable, ContentHashable {
        enum Size {
            case normal
            case small
            case large
        }

        let id: String
        let segments: [String]
        let selectedIndex: Int
        let size: Size

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }

        func contentHash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(segments)
            hasher.combine(selectedIndex)
            hasher.combine(size)
        }
    }

    private let store: Store<AppState, RootFeature.Action>

    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Int, ItemType>!
    private var switches: [UISwitch] = []

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
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemType>()
        snapshot.appendSections([0])
        let newData = state.data.map({ element -> ItemType in
            switch element {
            case let .boolData(boolData):
                let item = SwitchItem(
                    id: boolData.id,
                    isOn: boolData.isOn,
                    size: {
                        switch boolData.state {
                        case .highlighted:
                            return .large
                        case .normal:
                            return .normal
                        case .disabled:
                            return .small
                        }
                    }()
                )
                return ItemType.switchItem(item)

            case let .segmentData(segmentData):
                let item = SegmentItem(
                    id: segmentData.id,
                    segments: segmentData.segments,
                    selectedIndex: segmentData.selectedIndex,
                    size: {
                        switch segmentData.state {
                        case .highlighted:
                            return .large
                        case .normal:
                            return .normal
                        case .disabled:
                            return .small
                        }
                    }()
                )
                return ItemType.segmentItem(item)
            }
        })
        snapshot.appendItems(newData)

        let previousSnapshot = dataSource.snapshot()
        previousSnapshot.sectionIdentifiers.forEach { sectionIdentifier in
            if snapshot.sectionIdentifiers.contains(sectionIdentifier) {
                if let foundItem = snapshot.itemIdentifiers(inSection: sectionIdentifier).first(where: { itemIdentifier in
                    newData.contains(itemIdentifier)
                }) {
                    var foundItemHasher = Hasher()
                    foundItem.contentHash(into: &foundItemHasher)
                    let foundItemHash = foundItemHasher.finalize()

                    let foundItemType = newData.first { itemType in
                        itemType == foundItem
                    }!

                    var foundItemTypeHasher = Hasher()
                    foundItemType.contentHash(into: &foundItemTypeHasher)
                    let foundItemTypeHash = foundItemTypeHasher.finalize()

                    if foundItemHash != foundItemTypeHash {
                        if #available(iOS 15.0, *) {
                            snapshot.reconfigureItems([foundItem])
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }

            }
        }
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

        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchTableViewCell")
        tableView.register(SegmentedTableViewCell.self, forCellReuseIdentifier: "SegmentedTableViewCell")
    }

    private func createDataSource() {
        let dataSource = UITableViewDiffableDataSource<Int, ItemType>(
            tableView: tableView,
            cellProvider: { [unowned self] tableView, indexPath, itemIdentifier in
                self.getCell(for: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
            }
        )
        dataSource.defaultRowAnimation = .right

        self.dataSource = dataSource
    }

    private func getCell(for tableView: UITableView, indexPath: IndexPath, itemIdentifier: ItemType) -> UITableViewCell {
        switch itemIdentifier {
        case .switchItem(let item):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SwitchTableViewCell",
                for: indexPath
            ) as! SwitchTableViewCell
            let id = item.id
            cell.configure(isOn: item.isOn, switchDidChange: { [weak self, id] isOn in
                guard let self = self else { return }
                if isOn {
                    self.store.dispatch(.setOn(id: id))
                } else {
                    self.store.dispatch(.setOff(id: id))
                }
            })
            return cell

        case let .segmentItem(item):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SegmentedTableViewCell",
                for: indexPath
            ) as! SegmentedTableViewCell
            let id = item.id
            cell.configure(
                segments: item.segments,
                selectedIndex: item.selectedIndex,
                segmentDidChange: { [weak self] selectedIndex in
                    print(selectedIndex)
                }
            )
            return cell
        }
    }
}
