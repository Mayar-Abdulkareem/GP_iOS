//
//  SearchFilterViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 17/12/2023.
//

import UIKit

protocol FilterViewControllerDelegate {
    func filterViewControllerDismissed()
}

class FilterViewController: UIViewController {
    
    // - TODO: weak var error
    var delegate: FilterViewControllerDelegate?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.showDefaultNavigationBar(title: String.LocalizedKeys.filterTitle.localized, withCloseButton: true)
        setupClearButton()
        view.addViewFillEntireView(tableView)
    }
    
    /// Change the filter icon configuration
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.filterViewControllerDismissed()
    }
    
    func setupClearButton() {
        let clearButton = UIBarButtonItem(title: String.LocalizedKeys.clearTitle.localized, style: .plain, target: self, action: #selector(clearButtonTapped))
        navigationItem.rightBarButtonItem = clearButton
    }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clearButtonTapped() {
        viewModel.selectedFilterRows.removeAll()
        tableView.reloadData()
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
    }
}