//
//  PeerMatchingViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/01/2024.
//

import UIKit

class PeerMatchingViewController: UIViewController, GradProNavigationControllerProtocol {

    private lazy var tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear

        tableView.register(
            MySkillsTableViewCell.self,
            forCellReuseIdentifier: MySkillsTableViewCell.identifier
        )

        tableView.register(
            PeerSkillsTableViewCell.self,
            forCellReuseIdentifier: PeerSkillsTableViewCell.identifier
        )

        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .disabled,
            primaryButtonTitle: "Match With Peer",
            secondaryButtonType: .secondary,
            secondaryButtonTitle: nil
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()

    private let viewModel = PeerMatchingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindWithViewModel()
        startLoading()
        viewModel.getCategories()
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary
        
        addNavBar(with: "Peer Matching")

        view.addSubview(tableView)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
            self?.stopLoading()
        }

        viewModel.onCategoriesFetched = { [weak self] in
            self?.stopLoading()
            self?.tableView.reloadData()
        }
    }

    func startLoading() {
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

extension PeerMatchingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .mySkills:
            return 1
        case .peerSkills:
            return viewModel.peerSkillsTitles.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .mySkills:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MySkillsTableViewCell.identifier,
                for: indexPath
            ) as? MySkillsTableViewCell
            cell?.configureCell(mySkills: MatchingPeerManager.shared.getMySkillsAttributedString())
            return cell ?? UITableViewCell()

        case .peerSkills:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PeerSkillsTableViewCell.identifier,
                for: indexPath
            ) as? PeerSkillsTableViewCell
            cell?.configureCell(with: viewModel.getCellModel(index: indexPath.row))
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .peerSkills = viewModel.sections[indexPath.section] {
            if indexPath.row == 0 || indexPath.row == 1 {
                footerView.changePrimaryButtonType(type: .primary)
            } else {
                footerView.changePrimaryButtonType(type: .disabled)
            }
            viewModel.selectedIndex = indexPath.row
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PeerMatchingHeaderView()
        headerView.backgroundColor = .clear
        headerView.configure(
            title: viewModel.sections[section].getTitle(),
            isEditButtonHidden: viewModel.sections[section].isEditButtonHidden
        )
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
