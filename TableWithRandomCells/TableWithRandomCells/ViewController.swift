//
//  ViewController.swift
//  TableWithRandomCells
//
//  Created by Vyacheslav Pronin on 12.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    struct Task {
        let number: Int
        var isDone: Bool = false
    }
    
    private lazy var tasks = Array(1...30).map { Task(number: $0) }
    private var dataSource: UITableViewDiffableDataSource<Int, String>?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alwaysBounceVertical = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        setupNavigation()
        setupTableView()
        setpConstraint()
        apply()
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        tasks[indexPath.row].isDone = !tasks[indexPath.row].isDone

        guard tasks[indexPath.row].isDone else {
            cell.accessoryType = .none
            return
        }

        cell.accessoryType = .checkmark
        
        let selectTask = tasks[indexPath.row]
        tasks.remove(at: indexPath.row)
        tasks.insert(selectTask, at: .zero)

        apply()
    }
    
}

private extension ViewController {
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func setpConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    func setupNavigation() {
        title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tapShuffle))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        view.backgroundColor = .systemIndigo
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self else { return .init() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.accessoryType = self.tasks[indexPath.row].isDone ? .checkmark : .none
            
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = "\(self.tasks[indexPath.row].number)"
            cell.contentConfiguration = contentConfiguration
            
            return cell
        }
    }
    
    func apply() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(tasks.map { String($0.number) }, toSection: .zero)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    @objc
    func tapShuffle() {
        tasks.shuffle()
        apply()
    }
}
