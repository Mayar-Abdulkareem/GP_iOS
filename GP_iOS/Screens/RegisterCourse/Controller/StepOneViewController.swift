//
//  StepOneViewController.swift
//  GP_iOS
//
//  Created by FTS on 31/12/2023.
//

import UIKit

class StepOneViewController: RegisterViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)

        tableView.register(
            RegisterTableViewCell.self,
            forCellReuseIdentifier: RegisterTableViewCell.identifier
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
            cuurrentStepText: String.LocalizedKeys.stepOneText.localized,
            nextStepText: String.LocalizedKeys.stepOneNextText.localized,
            leftButtonText: String.LocalizedKeys.backButtonTitle.localized,
            rightButtonText:String.LocalizedKeys.nextButtonText.localized
        )
        bindWithViewModel()
        configureViews()
        startLoading()
        viewModel.fetchAvailableCourses()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
            self?.stopLoading()
        }

        viewModel.onAvailableCoursesFetched = { [weak self] noAvailableCourses in
            self?.stopLoading()
            if noAvailableCourses {
                self?.tableView.setEmptyView(message: String.LocalizedKeys.noAvailableCourses.localized)
            } else {
                self?.tableView.removeEmptyView()
            }
            self?.tableView.reloadData()
        }
    }

    private func configureViews() {
        middleView.addViewFillEntireView(tableView)
    }
}

extension StepOneViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.availableCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RegisterTableViewCell.identifier,
            for: indexPath
        ) as? RegisterTableViewCell ?? RegisterTableViewCell()
        
        cell.configureCell(
            with: RegisterCellModel(
                title: viewModel.availableCourses[indexPath.row].courseName,
                iconImage: UIImage.SystemImages.projectType.image,
                isIconHidden: false,
                isLastCell: (indexPath.row == (viewModel.availableCourses.count - 1))
            )
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.selectedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            viewModel.selectedCourse = nil
            enableRightButton(isEnabled: false)
            viewModel.selectedIndexPath = nil
        } else {
            viewModel.selectedCourse = viewModel.availableCourses[indexPath.row]
            enableRightButton(isEnabled: true)
            viewModel.selectedIndexPath = indexPath
        }
    }
}
