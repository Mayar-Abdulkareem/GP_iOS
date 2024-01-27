//
//  StepThreeViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 01/01/2024.
//

import UIKit
import FHAlert

class StepThreeViewController: RegisterViewController, TagListViewDelegate {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(
            cuurrentStepText: String.LocalizedKeys.stepThreeText.localized,
            nextStepText: ""
        )
        bindWithViewModel()
        configureViews()
        startLoading()
        viewModel.getCategories()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            TopAlertView.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: TopAlertType.failure)
            self?.stopLoading()
        }

        viewModel.onCategoriesFetched = { [weak self] noCategories in
            self?.stopLoading()
            if noCategories {
                self?.tableView.setEmptyView(message: String.LocalizedKeys.noPrevProjects.localized)
            } else {
                self?.tableView.removeEmptyView()
            }
            self?.tableView.reloadData()
        }
    }

    private func configureViews() {
        let headerView = SkillsTableViewHeader(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 70))
        tableView.tableHeaderView = headerView

        changePrimaryButtonTitle(text: "FINISH")
        enablePrimaryButton()
        middleView.addViewFillEntireView(tableView, top: 16)
    }
}

extension StepThreeViewController: UITableViewDelegate, UITableViewDataSource {
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

extension StepThreeViewController: SkillsTableViewCellDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView, section: Int?) {
        guard let section = section else { return }
        viewModel.categoriesWithSkills[section].skills[tagView.tag].isSelected.toggle()
    }
}
