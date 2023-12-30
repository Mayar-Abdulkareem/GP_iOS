//
//  SearchFilterViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 17/12/2023.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func filterViewControllerDismissed()
}

class FilterViewController: UIViewController {

    weak var delegate: FilterViewControllerDelegate?

    var viewModel: SearchViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(
            FilterTableViewCell.self,
            forCellReuseIdentifier: FilterTableViewCell.identifier
        )
        tableView.register(
            FilterHeaderView.self,
            forHeaderFooterViewReuseIdentifier: FilterHeaderView.identifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private lazy var filterButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String.LocalizedKeys.filterTitle.localized, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.mySecondary
        button.tintColor = UIColor.myPrimary
        button.layer.cornerRadius = 10

        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.filterViewControllerDismissed()
            self?.viewModel.previousSelection = self?.viewModel.selectedFilterRows ?? []
            self?.dismiss(animated: true)

        }, for: .primaryActionTriggered)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.showDefaultNavigationBar(
            title: String.LocalizedKeys.filterTitle.localized,
            withCloseButton: true
        )
        updateFilterButtonState()
        setupClearButton()
        configureViews()
    }

    private func configureViews() {
        view.backgroundColor = .myLightGray

        view.addSubview(tableView)
        view.addSubview(filterButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            filterButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            filterButton.widthAnchor.constraint(equalToConstant: 180),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func setupClearButton() {
        let clearButton = UIBarButtonItem(
            title: String.LocalizedKeys.clearTitle.localized,
            style: .plain,
            target: self,
            action: #selector(clearButtonTapped)
        )
        navigationItem.rightBarButtonItem = clearButton
    }

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateFilterButtonState() {
        let isSelectionChanged = viewModel.selectedFilterRows != viewModel.previousSelection
        // let isSelectionNotEmpty = !viewModel.selectedFilterRows.isEmpty
        filterButton.isEnabled = isSelectionChanged
    }

    @objc func clearButtonTapped() {
        viewModel.selectedFilterRows.removeAll()
        tableView.reloadData()
        updateFilterButtonState()
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell ?? FilterTableViewCell()
        let category = viewModel.categories[indexPath.section].1[indexPath.row]
        let isSelected = viewModel.selectedFilterRows.contains(indexPath)
        cell.configureCell(title: category, isSelected: isSelected)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterHeaderView.identifier) as? FilterHeaderView else {
            return nil
        }
        let title = viewModel.categories[section].0
        headerView.configure(title: title)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Check if the indexPath is already in the selectedRows array
        if let existingIndex = viewModel.selectedFilterRows.firstIndex(of: indexPath) {
            /// Remove the indexPath if it exists
            viewModel.selectedFilterRows.remove(at: existingIndex)
        } else {
            /// Check if there is any selected indexPath from the same section and it's in section 0
            if let selectedIndexPathInSection = viewModel.selectedFilterRows.first(where: { $0.section == indexPath.section && $0.section == 0 && $0.row != indexPath.row }) {
                /// Remove the existing selection in the same section
                viewModel.selectedFilterRows.removeAll { $0 == selectedIndexPathInSection }
            }
            /// Add the indexPath to the selectedRows array
            viewModel.selectedFilterRows.append(indexPath)
        }
        tableView.reloadData()
        updateFilterButtonState()
    }
}
