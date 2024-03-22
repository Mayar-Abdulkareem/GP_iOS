//
//  TopMatchedViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 20/01/2024.
//

import UIKit

class TopMatchedViewController: UIViewController, GradProNavigationControllerProtocol {

    private var topMatchedStudents: [Peer]

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none

        tableView.register(
            TopMatchedTableViewCell.self,
            forCellReuseIdentifier: TopMatchedTableViewCell.identifier
        )

        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .mySecondary
        return label
    }()

    init(topMatchedStudents: [Peer]) {
        self.topMatchedStudents = topMatchedStudents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(statusLabel)
        configureNavBarTitle(title:  "Top Matched")
        addSeparatorView()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension TopMatchedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topMatchedStudents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopMatchedTableViewCell.identifier, for: indexPath) as? TopMatchedTableViewCell else {
            return UITableViewCell()
        }
        let student = topMatchedStudents[indexPath.row]
        let isLastCell = indexPath.row == (topMatchedStudents.count - 1)
        let cellModel = TopMatchedCellModel(peer: student, isLastCell: isLastCell)
        cell.configureCell(with: cellModel)
        return cell
    }
}
