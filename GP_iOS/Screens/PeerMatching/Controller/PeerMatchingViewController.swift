//
//  PeerMatchingViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/01/2024.
//

import UIKit
import FHAlert
//import FirebaseAnalytics

class PeerMatchingViewController: UIViewController, GradProNavigationControllerProtocol {

    weak var coordinator: PeerCoordinator?

    private lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor.myPrimary

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

    private lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .disabled,
            primaryButtonTitle: "Match With Peer",
            secondaryButtonType: .secondary,
            secondaryButtonTitle: nil
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
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

    override func viewWillAppear(_ animated: Bool) {
        if !viewModel.customSkillsSelected {
            viewModel.selectedIndex = -1
            footerView.changePrimaryButtonType(type: .disabled)
        }
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary

        addBackButton()
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
            TopAlertView.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: TopAlertType.failure)
            self?.stopLoading()
        }

        viewModel.onCategoriesFetched = { [weak self] in
            self?.stopLoading()
            self?.tableView.reloadData()
        }

        viewModel.onPeerMatched = { [weak self] in
            self?.stopLoading()
            guard let topMatchedStudents = self?.viewModel.matchedStudents else { return }
            self?.coordinator?.showTopMatchedViewController(topMatchedStudents: topMatchedStudents)
        }
    }

    private func startLoading() {    
        self.navigationController?.navigationBar.tintColor = .white
        tableView.alpha = 0
        view.showLoading(maskView: view, hasTransparentBackground: true)
    }

    private func stopLoading() {
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
                viewModel.customSkillsSelected = false
                footerView.changePrimaryButtonType(type: .primary)
            } else {
                coordinator?.showSkillsViewController(categories: AppManager.shared.categories, context: .customSkillsForPeer, delegate: self)
            }
            viewModel.selectedIndex = indexPath.row
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PeerMatchingHeaderView()
        headerView.backgroundColor = .white
        headerView.configure(
            title: viewModel.sections[section].getTitle(),
            isEditButtonHidden: viewModel.sections[section].isEditButtonHidden
        )
        headerView.delegate = self
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

extension PeerMatchingViewController: EditMySkillsProtocol {
    func editButtonTapped() {
        let studentCategories = MatchingPeerManager.shared.getSelectedSkills(categories: AppManager.shared.categories)
        coordinator?.showSkillsViewController(categories: studentCategories, context: .editStudentSkills, delegate: self)
    }
}

extension PeerMatchingViewController: SkillsViewControllerProtocol {
    func saveButtonTapped(skillsVector: String, context: SkillsViewType) {
        switch context {
        case .editStudentSkills:
            tableView.reloadData()
        case .customSkillsForPeer:
            viewModel.customSkills = skillsVector
            viewModel.customSkillsSelected = true
            viewModel.selectedIndex = -1
            tableView.reloadData()
            footerView.changePrimaryButtonType(type: .primary)
        }
    }
}

extension PeerMatchingViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        //Analytics.logEvent("Button_Clicked", parameters: nil)
        startLoading()
        viewModel.matchWithPeer()
    }
}
