//
//  ProjectDetailsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 18/12/2023.
//

import UIKit

class ProjectDetailsViewController: UIViewController, GradProNavigationControllerProtocol {

    private let viewModel = ProjectDetailsViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .myPrimary

        tableView.register(
            LabelIconTableViewCell.self,
            forCellReuseIdentifier: LabelIconTableViewCell.identifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .primary,
            primaryButtonTitle: String.LocalizedKeys.driveLink.localized,
            secondaryButtonType: .disabled,
            secondaryButtonTitle: nil
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
        return footerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    private func configureViews() {
        view.backgroundColor = UIColor.myPrimary

        addNavBar(with: AppManager.shared.prevProject?.name)
        addNavCloseButton()

        view.addSubview(tableView)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

extension ProjectDetailsViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        if let link = AppManager.shared.prevProject?.link, let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}

extension ProjectDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellsModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LabelIconTableViewCell.identifier,
            for: indexPath
        ) as? LabelIconTableViewCell
        cell?.configureCell(model: viewModel.cellsModel[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
