//
//  DetailsViewController.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import UIKit
import Highway

class DetailsViewController: UIViewController {
    enum Item {
        struct Section: Hashable {
            let id: Int
            var items: [AnyHashable]
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }
            
            static func == (lhs: Self, rhs: Self) -> Bool {
                lhs.id == rhs.id
            }
        }

        struct Title: Hashable {
            let id: String
            let value: String
        }

        struct Details: Hashable {
            let id: String
            let value: String
        }

        struct Image: Hashable {
            let id: String
            let value: URL
        }
    }
    
    private let store: Store<RootFeature.State, DetailsFeature.Action>

    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Item.Section, AnyHashable>!
    
    init(
        store: Store<RootFeature.State, DetailsFeature.Action>
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
        tableView.delegate = self
        
        self.tableView = tableView
    }
    
    private func registerCells() {
        tableView.register(TitleTableViewCell.self)
        tableView.register(DetailsTableViewCell.self)
        tableView.register(ImageTableViewCell.self)
    }
    
    private func createDataSource() {
        let dataSource = UITableViewDiffableDataSource<Item.Section, AnyHashable>(
            tableView: tableView
        ) { tableView, indexPath, itemIdentifier in
            self.getCell(for: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
        }
        dataSource.defaultRowAnimation = .fade
        
        self.dataSource = dataSource
    }
    
    private func getCell(
        for tableView: UITableView,
        indexPath: IndexPath,
        itemIdentifier: AnyHashable
    ) -> UITableViewCell? {
        switch itemIdentifier {
        case let titleItem as Item.Title:
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

        case let detailsItem as Item.Details:
            let cell = tableView.dequeueReusableCell(DetailsTableViewCell.self)
            cell.configure(
                title: detailsItem.value,
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

        case let imageItem as Item.Image:
            let cell = tableView.dequeueReusableCell(ImageTableViewCell.self)
            cell.configure(imageURL: imageItem.value)
            return cell
            
        default:
            fatalError("Unexpected state")
        }
    }
    
    private func createSnapshot(from state: RootFeature.State) {
        print(state.data)
        
        var snapshot = NSDiffableDataSourceSnapshot<Item.Section, AnyHashable>()
        let sections = parse(sections: state.data)
        snapshot.appendSections(sections)
        sections.forEach { section in   
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource.apply(snapshot)
    }
    
    private func parse(sections: [RootFeature.State.Section]) -> [Item.Section] {
        return sections.map { section in
            Item.Section(
                id: section.id,
                items: section.items.map({ item in
                    switch item {
                    case let item as RootFeature.State.Section.Title:
                        return Item.Title(id: item.id, value: item.value)
                        
                    case let item as RootFeature.State.Section.Details:
                        return Item.Details(id: item.id, value: item.value)

                    case let item as RootFeature.State.Section.Image:
                        return Item.Image(id: item.id, value: item.value)

                    default:
                        fatalError("Unexpected state")
                    }
                })
            )
        }
    }
}

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemIdentifier = dataSource.itemIdentifier(for: indexPath)
        switch itemIdentifier {
        case is Item.Title:
            break
            
        case is Item.Details:
            break
            
        case is Item.Image:
            store.dispatch(.updateRow(value: indexPath))

        default:
            fatalError("Unexpected state")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionIdentifier = dataSource.sectionIdentifier(for: section)!
        let header = UITableViewHeaderFooterView()
        header.textLabel?.text = "Section #\(sectionIdentifier.id) (Tap to remove)"
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionIdentifier = dataSource.sectionIdentifier(for: section)!
        let footer = UITableViewHeaderFooterView()
        footer.textLabel?.text = "Footer #\(sectionIdentifier.id) (Tap to add new section)"
        return footer
    }
}
