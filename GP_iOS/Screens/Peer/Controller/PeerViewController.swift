//
//  PeerViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import UIKit

class PeerViewController: UIViewController, GradProNavigationControllerProtocol {
    weak var coordinator: PeerCoordinator?
    private let viewModel = PeerViewModel()

    private lazy var tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear

        tableView.register(
            PeerTableViewCell.self,
            forCellReuseIdentifier: PeerTableViewCell.identifier
        )

        tableView.register(
            HeaderTableViewCell.self,
            forCellReuseIdentifier: HeaderTableViewCell.identifier
        )

        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = UIColor.mySecondary
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .primary,
            primaryButtonTitle: String.LocalizedKeys.cancelRequestButtonTitle.localized,
            secondaryButtonType: .disabled,
            secondaryButtonTitle: nil
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.isHidden = true
        footerView.delegate = self
        return footerView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        startLoading()
        viewModel.setViewType()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindWithViewModel()
        configureViews()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            self?.stopLoading()
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
        }

        viewModel.onRequestSent = { [weak self]  in
            self?.stopLoading()
            self?.showStatus(message: "Waiting for your peer approval")
            self?.footerView.isHidden = false
            TopAlertManager.show(title: "Success", subTitle: "Successfully sent a request", type: .success)
        }

        viewModel.onRequestCanceled = { [weak self] in
            if self?.viewModel.viewType == .sendRequset {
                self?.stopLoading()
                self?.hideStatus()
                self?.footerView.isHidden = true
                TopAlertManager.show(title: "Success", subTitle: "Successfully canceled your request", type: .success)
            }
        }

        viewModel.onRequestFetched = { [weak self] in
            self?.stopLoading()
            switch self?.viewModel.viewType {
            case .sendRequset:
                self?.hideStatus()
                self?.footerView.isHidden = true
            case .pending:
                self?.showStatus(message: "Waiting for your peer approval")
                self?.footerView.isHidden = false
            case .accepted:
                self?.showStatus(message: "You can't have more than one peer.")
                self?.footerView.isHidden = true
            case .none:
                self?.hideStatus()
            }
        }
    }

    func showStatus(message: String) {
        tableView.alpha = 0
        statusLabel.isHidden = false
        statusLabel.text = message
    }

    func hideStatus() {
        tableView.alpha = 1
        statusLabel.isHidden = true
    }

    private func configureViews() {
        view.backgroundColor = UIColor.myPrimary

        view.addSubview(tableView)
        view.addSubview(statusLabel)
        view.addSubview(footerView)

        configureNavBarTitle(title: String.LocalizedKeys.choosePeerTitle.localized)
        addSeparatorView()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -54),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func startLoading() {
        footerView.isHidden = true
        statusLabel.isHidden = true
        tableView.alpha = 0
        view.showLoading(maskView: view, hasTransparentBackground: true)
    }

    func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
        view.hideLoading()
    }
}

extension PeerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].getTitle()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .header:
            return 1
        case .options:
            return viewModel.options.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .header:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HeaderTableViewCell.identifier,
                for: indexPath
            ) as? HeaderTableViewCell
            cell?.configureCell(
                model: HeaderTableViewCellModel(
                    title: "Find Your Match",
                    subtitle: "Connect with a peer who shares your interests and goals.",
                    image: .peer
                )
            )
            return cell ?? UITableViewCell()

        case .options:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PeerTableViewCell.identifier,
                for: indexPath
            ) as? PeerTableViewCell
            cell?.configureCell(with: viewModel.getCellModel(index: indexPath.row))
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .options = viewModel.sections[indexPath.section] {
            switch indexPath.row {
            case 0:
                coordinator?.showSelectPeerViewController()
            default:
                coordinator?.showMatchingPeerViewController()
            }
        }
    }
}

extension PeerViewController: SelectPeerViewControllerDelegate {
    func sendRequest(peerID: String) {
        startLoading()
        viewModel.sendPeerRequest(peerID: peerID)
    }
}

extension PeerViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        startLoading()
        viewModel.cancelPeerRequest()
    }
}
