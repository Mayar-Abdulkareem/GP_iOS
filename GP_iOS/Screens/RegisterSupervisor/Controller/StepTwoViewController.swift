//
//  StepTwoViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 01/01/2024.
//

import UIKit

class StepTwoViewController: RegisterViewController {

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

    private let requestLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = UIColor.mySecondary
        return label
    }()

    private lazy var pendingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = UIColor.gray
        return label
    }()

    private lazy var requestButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String.LocalizedKeys.sendRequestButtonTitle.localized, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.mySecondary
        button.tintColor = UIColor.myPrimary
        button.layer.cornerRadius = 10

        button.addAction(UIAction { [weak self] _ in
            self?.startLoading()
            // Send request
            if self?.viewModel.requestStatus == .notSent {
                self?.viewModel.postRequest()
            } else {
                // Cancel request
                self?.viewModel.deleteRequest()
            }
        }, for: .primaryActionTriggered)
        return button
    }()

    func startLoading() {
        requestLabel.isHidden = true
        pendingLabel.isHidden = true
        tableView.alpha = 0
        view.showLoading(maskView: view, hasTransparentBackground: true)
    }

    func stopLoading() {
        requestLabel.isHidden = true
        pendingLabel.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
        view.hideLoading()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(
            cuurrentStepText: String.LocalizedKeys.stepTwoText.localized,
            nextStepText: String.LocalizedKeys.stepTwoNextText.localized,
            leftButtonText: String.LocalizedKeys.backButtonTitle.localized,
            leftButtonEnable: true,
            rightButtonText: String.LocalizedKeys.nextButtonText.localized
        )
        bindWithViewModel()
        configureViews()
        if viewModel.requestStatus == .notSent {
            startLoading()
            viewModel.fetchAvailableSupervisors()
        }
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
            self?.stopLoading()
        }

        viewModel.onAvailableSupervisorsFetched = { [weak self] noAvailableSupervisors in
            self?.stopLoading()
            if noAvailableSupervisors {
                self?.tableView.setEmptyView(message: String.LocalizedKeys.noAvailableSupervisors.localized)
            } else {
                self?.tableView.removeEmptyView()
            }
            self?.tableView.reloadData()
            self?.configureViewType()
        }

        viewModel.onRequestSent = { [weak self] in
            self?.stopLoading()
            self?.configureViewType()
        }
    }

    private func showTableView() {
        requestLabel.isHidden = true
        requestButton.isHidden = true
    }

    private func configureViews() {
        middleView.addSubview(tableView)
        middleView.addSubview(requestButton)
        middleView.addSubview(requestLabel)
        middleView.addSubview(pendingLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: middleView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: requestButton.topAnchor, constant: -8),

            requestButton.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            requestButton.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -16),
            requestButton.widthAnchor.constraint(equalToConstant: 150),

            requestLabel.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 16),
            requestLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            requestLabel.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -16),

            pendingLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            pendingLabel.centerYAnchor.constraint(equalTo: middleView.centerYAnchor, constant: -16),
        ])
        configureViewType()
    }

    private func configureViewType() {
        switch viewModel.requestStatus {
        case .notSent:
            tableView.isHidden = false
            requestButton.isHidden = false
            requestButton.isEnabled = false
            requestLabel.isHidden = true
            pendingLabel.isHidden = true
            enableLeftButton(isEnabled: true)
        case .pending:
            enableLeftButton(isEnabled: false)
            tableView.isHidden = true
            requestButton.isHidden = false
            requestLabel.isHidden = false
            pendingLabel.isHidden = false
            enableLeftButton(isEnabled: false)
        case .accepted:
            tableView.isHidden = true
            requestButton.isHidden = true
            requestLabel.isHidden = false
            pendingLabel.isHidden = true
            enableLeftButton(isEnabled: false)
            enableRightButton(isEnabled: true)
        }
        requestLabel.text = viewModel.requestStatus.requestLabelText
        requestButton.setTitle(viewModel.requestStatus.requestButtonText, for: .normal)
        pendingLabel.text = String.LocalizedKeys.waitingPartOne.localized + " " + (viewModel.selectedSupervisor?.name ?? viewModel.request?.receiverName ?? "") + " " + String.LocalizedKeys.waitingPartTwo.localized
    }
}

extension StepTwoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.availableSupervisors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RegisterTableViewCell.identifier,
            for: indexPath
        ) as? RegisterTableViewCell ?? RegisterTableViewCell()
        cell.configureCell(
            with: RegisterCellModel(
                title: viewModel.availableSupervisors[indexPath.row].name,
                iconImage: (viewModel.availableSupervisors[indexPath.row].isFull ? UIImage.SystemImages.closeLock.image : UIImage.SystemImages.openLock.image),
                isIconHidden: false, 
                isLastCell: indexPath.row == (viewModel.availableSupervisors.count - 1))
            )
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.selectedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            viewModel.selectedSupervisor = nil
            requestButton.isEnabled = false
            viewModel.selectedIndexPath = nil
        } else {
            viewModel.selectedSupervisor = viewModel.availableSupervisors[indexPath.row]
            requestButton.isEnabled = true
            viewModel.selectedIndexPath = indexPath
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if viewModel.availableSupervisors[indexPath.row].isFull {
            return nil
        } else {
            return indexPath
        }
    }
}
