//
//  RootViewController.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import UIKit
import Highway

class RootViewController: UIViewController {
    
    private let store: Store<RootFeature.State, RootFeature.Action>

    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<RootFeature.SectionItem, AnyHashable>!
    
    init(
        store: Store<RootFeature.State, RootFeature.Action>
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
        registerCells()
        createDataSource()

        createSnapshot(from: store.state)
        store.subscribe { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                self?.createSnapshot(from: state)
            }
        }
    }

    private func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewConstraints = [
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        tableViewConstraints.forEach{ $0.isActive = true }
        
        self.tableView = tableView
    }
    
    private func registerCells() {
        tableView.register(TitleTableViewCell.self)
        tableView.register(DetailsTableViewCell.self)
        tableView.register(ImageTableViewCell.self)
    }
    
    private func createDataSource() {
        let dataSource = UITableViewDiffableDataSource<RootFeature.SectionItem, AnyHashable>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            self.getCell(for: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
        }
        
        self.dataSource = dataSource
    }
    
    private func getCell(
        for tableView: UITableView,
        indexPath: IndexPath,
        itemIdentifier: AnyHashable
    ) -> UITableViewCell? {
        switch itemIdentifier {
        case let titleItem as RootFeature.TitleItem:
            let cell = tableView.dequeueReusableCell(TitleTableViewCell.self)
            cell.configure(
                title: titleItem.value,
                deleteButtonAction: { [weak self] in
                    self?.store.dispatch(.deleteRow(value: indexPath))
                },
                updateButtonAction: { [weak self] in
                    self?.store.dispatch(.updateRow(value: indexPath))
                },
                insertButtonAction: { [weak self] in
                    self?.store.dispatch(.insertRow(value: indexPath))
                }
            )
            return cell

        case let detailsItem as RootFeature.DetailsItem:
            let cell = tableView.dequeueReusableCell(DetailsTableViewCell.self)
            cell.configure(details: detailsItem.value)
            return cell

        case let imageItem as RootFeature.ImageItem:
            let cell = tableView.dequeueReusableCell(ImageTableViewCell.self)
            cell.configure(imageURL: imageItem.value)
            return cell
            
        default:
            fatalError("Unexpected state")
        }
    }
    
    private func createSnapshot(from state: RootFeature.State) {
        print(state.data)
        
        var snapshot = NSDiffableDataSourceSnapshot<RootFeature.SectionItem, AnyHashable>()
        let section = state.data.first!
        snapshot.appendSections([section])
        snapshot.appendItems(section.items, toSection: section)

        dataSource.apply(snapshot)
    }
}
