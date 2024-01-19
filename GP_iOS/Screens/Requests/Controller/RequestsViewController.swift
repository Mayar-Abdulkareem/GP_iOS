//
//  RequestViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 19/01/2024.
//

import UIKit

class RequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var viewModel = RequestsViewModel()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RrquestTableViewCell.self, forCellReuseIdentifier: RrquestTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .mySecondary
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        startLoading()
        viewModel.setViewType()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onShowError = { [weak self] message in
            self?.stopLoading()
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: message, type: .failure)
        }

        viewModel.onViewTypeSpecified = { [weak self]  in
            self?.stopLoading()
            self?.configureViewType()
        }

        viewModel.onRequestsFetched = { [weak self] in
            self?.stopLoading()
            self?.configureViewType()
            self?.tableView.reloadData()
        }

        viewModel.onRequestAccepted = { [weak self] in
            self?.stopLoading()
            TopAlertManager.show(title: "Success", subTitle: "Request accepted successfully", type: .success)
            self?.configureViewType()
        }

        viewModel.onRequestDeclined = { [weak self] in
            self?.stopLoading()
            TopAlertManager.show(title: "Success", subTitle: "Request declined successfully", type: .success)
            self?.startLoading()
            self?.viewModel.setViewType()
        }
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

    private func configureViewType() {
        switch viewModel.viewType {
        case .noRequests:
            tableView.isHidden = true
            statusLabel.text = "You don't have any request."
            statusLabel.isHidden = false
        case .requestAccepted:
            tableView.isHidden = true
            statusLabel.text = "You can't have more than one peer."
            statusLabel.isHidden = false
        case .canAcceptRequests:
            tableView.isHidden = false
            statusLabel.isHidden = true
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

extension RequestsViewController {
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.requests?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RrquestTableViewCell.identifier, for: indexPath) as? RrquestTableViewCell,
              let request = viewModel.requests?[indexPath.row] else {
            return UITableViewCell()
        }
        let isLastCell = indexPath.row == (viewModel.requests?.count ?? 0) - 1
        let cellModel = RequestCellModel(peerID: request.senderID, peerName: request.senderName, isLastCell: isLastCell)
        cell.configureCell(with: cellModel)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acceptAction = UIContextualAction(style: .normal, title: "Accept") { [weak self] (action, view, completionHandler) in
            guard let peerID = self?.viewModel.requests?[indexPath.row].senderID else { return }
            self?.viewModel.acceptPeerRequest(peerID: peerID)
            completionHandler(true)
        }
        acceptAction.backgroundColor = .mySecondary

        let declineAction = UIContextualAction(style: .destructive, title: "Decline") { [weak self] (action, view, completionHandler) in
            guard let peerID = self?.viewModel.requests?[indexPath.row].senderID else { return }
            self?.viewModel.declinePeerRequest(peerID: peerID)
            completionHandler(true)
        }
        declineAction.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [declineAction, acceptAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
