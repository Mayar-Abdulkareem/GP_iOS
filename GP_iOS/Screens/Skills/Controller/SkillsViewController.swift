//
//  SkillsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 19/01/2024.
//

import UIKit
import FHAlert

protocol SkillsViewControllerProtocol: AnyObject {
    func saveButtonTapped(skillsVector: String, context: SkillsViewType)
}

class SkillsViewController: UIViewController, GradProNavigationControllerProtocol {

    let viewModel = SkillsViewModel()

    weak var delegate: SkillsViewControllerProtocol?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.register(
            SkillsTableViewCell.self,
            forCellReuseIdentifier: SkillsTableViewCell.identifier
        )

        tableView.register(
            CategoryHeaderView.self,
            forHeaderFooterViewReuseIdentifier: CategoryHeaderView.reuseIdentifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .disabled,
            primaryButtonTitle: String.LocalizedKeys.saveTitle.localized,
            secondaryButtonType: .secondary,
            secondaryButtonTitle: nil
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
        return footerView
    }()

    init(categories: [Category], context: SkillsViewType) {
        super.init(nibName: nil, bundle: nil)
        viewModel.categoriesWithSkills = categories
        viewModel.context = context
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindWithViewModel()
        configureViews()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            TopAlertView.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: TopAlertType.failure)
            self?.stopLoading()
        }

        viewModel.onSkillsUpdated = { [weak self]  in
            guard let self = self else { return }
            self.stopLoading()
            let skillsVector = MatchingPeerManager.shared.createVector(from: self.viewModel.categoriesWithSkills)
            delegate?.saveButtonTapped(skillsVector: skillsVector, context: self.viewModel.context)
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        configureNavBarTitle(title: "Skills")
        addSeparatorView()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
}

extension SkillsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categoriesWithSkills.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SkillsTableViewCell.identifier,
            for: indexPath
        ) as? SkillsTableViewCell ?? SkillsTableViewCell()

        let skills = viewModel.categoriesWithSkills[indexPath.section].skills

        cell.configureCell(
            skills: skills,
            section: indexPath.section
        )
        cell.layoutIfNeeded()
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CategoryHeaderView.reuseIdentifier
        ) as? CategoryHeaderView ?? CategoryHeaderView()

        header.configureCell(category: viewModel.categoriesWithSkills[section].title)

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension SkillsViewController: SkillsTableViewCellDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView, section: Int?) {
        footerView.changePrimaryButtonType(type: .primary)
        guard let section = section else { return }
        viewModel.categoriesWithSkills[section].skills[tagView.tag].isSelected.toggle()
    }
}

extension SkillsViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        let skillsVector = MatchingPeerManager.shared.createVector(from: viewModel.categoriesWithSkills)
        switch viewModel.context {
        case .editStudentSkills:
            AppManager.shared.categories = viewModel.categoriesWithSkills
            startLoading()
            viewModel.updateSkillsVector(skillsVector: skillsVector)
        case .customSkillsForPeer:
            delegate?.saveButtonTapped(skillsVector: skillsVector, context: viewModel.context)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
