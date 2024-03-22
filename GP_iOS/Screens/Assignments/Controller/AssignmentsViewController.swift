//
//  AssignmentsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 14/12/2023.
//

import UIKit
import FHAlert

class AssignmentsViewController: UIViewController, GradProNavigationControllerProtocol {
    
    weak var coordinator: CourseCoordinator?
    private var viewModel = AssignmentsViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .myPrimary

        tableView.register(
            AssignmentTableViewCell.self,
            forCellReuseIdentifier: AssignmentTableViewCell.identifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindWithViewModel()
        configureViews()
        startLoading()
        viewModel.getAllAssignments()
    }

    private func startLoading() {
        tableView.alpha = 0
        view.showLoading(maskView: view, hasTransparentBackground: true)
    }

    private func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
        view.hideLoading()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            self?.stopLoading()
            TopAlertView.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: TopAlertType.failure)
        }

        viewModel.onAssignmentsFetched = { [weak self] noAssignments in
            self?.stopLoading()
            if noAssignments {
                self?.tableView.setEmptyView(message: String.LocalizedKeys.noAssignments.localized)
            } else {
                self?.tableView.removeEmptyView()
            }
            self?.tableView.reloadData()
        }
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        configureNavBarTitle(title: String.LocalizedKeys.assignmentsTitle.localized)
        addBackButton()
        addSeparatorView()
    }
}

extension AssignmentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AssignmentTableViewCell.identifier,
            for: indexPath
        ) as? AssignmentTableViewCell
        cell?.configureCell(model: viewModel.getCellModel(index: indexPath.row))
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppManager.shared.assignment = viewModel.assignments[indexPath.row]
//        switch Role.getRole() {
//        case .student:
            coordinator?.showSubmissionsViewController()
//        case .supervisor:
//
//        }
    }
}
