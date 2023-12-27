//
//  SearchViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    weak var coordinator: SearchCoordinator?
    
    private let viewModel = SearchViewModel()
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        tableView.register(
            SearchTableViewCell.self,
            forCellReuseIdentifier: SearchTableViewCell.identifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = String.LocalizedKeys.searchByProjectName.localized
        searchBar.layer.borderWidth = 0
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .mySecondary
        
        searchBar.delegate = self
        
        return searchBar
    }()
    
    private lazy var filterButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.SystemImages.filter.image
        configuration.imagePlacement = .all
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.gray
        
        button.addAction(UIAction { [weak self] _ in
            self?.coordinator?.presentFilterViewController(with: self?.viewModel)
        }, for: .primaryActionTriggered)
                               
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindWithViewModel()
        configureViews()
        startLoading()
        viewModel.fetchProjectTypes()
        viewModel.fetchPrevProjects()
    }
    
    func startLoading() {
        tableView.alpha = 0
        showLoading(maskView: view, hasTransparentBackground: true)
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
        hideLoading()
    }
    
    private func configureViews() {
        view.backgroundColor = UIColor.myPrimary
        
        view.addSubview(searchBar)
        view.addSubview(filterButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            filterButton.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalTo: searchBar.heightAnchor),
            filterButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor)
        ])
    }
    
    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
            self?.stopLoading()
        }
        
        viewModel.onPreviousProjectsFetched = { [weak self] noPrevProject in
            self?.stopLoading()
            if noPrevProject {
                self?.tableView.setEmptyView(message: String.LocalizedKeys.noPrevProjects.localized)
            } else {
                self?.tableView.removeEmptyView()
            }
            self?.tableView.reloadData()
        }
    }
    
    func configureFilterButton() {
        filterButton.tintColor = viewModel.selectedFilterRows.isEmpty ? UIColor.gray : UIColor.mySecondary
        filterButton.configuration?.image = viewModel.selectedFilterRows.isEmpty ?  UIImage.SystemImages.filter.image : UIImage.SystemImages.filterFill.image
    }
    
    @objc private func filterButtonTapped() {
        coordinator?.presentFilterViewController(with: viewModel)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.prevProjects.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let currentProject: PreviousProject = viewModel.prevProjects[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell ?? SearchTableViewCell()
            cell.configureCell(
                model: PreviousProject(
                    name: currentProject.name,
                    projectType: currentProject.projectType,
                    date: currentProject.date,
                    students: currentProject.students,
                    supervisor: String.LocalizedKeys.doctorInitital.localized + " " + currentProject.supervisor,
                    description: currentProject.description,
                    link: currentProject.link
                )
            )
            
            if (indexPath.row == viewModel.prevProjects.count - 1) && (indexPath.row < (viewModel.totalPrevProjectsCount - 1)) {
                /// Check if the current row is the last one and it is loading
                viewModel.isLastResult = false
                viewModel.searchFilterModel.page += 1
                viewModel.fetchPrevProjects()
            } else if (indexPath.row == viewModel.prevProjects.count - 1) && (indexPath.row == viewModel.totalPrevProjectsCount - 1) {
                /// Check if the current row is the last one and there are no more pages
                viewModel.isLastResult = true
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppManager.shared.prevProject = viewModel.prevProjects[indexPath.row]
        coordinator?.presentProjectDetailsViewController()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 && (!viewModel.prevProjects.isEmpty){
            let footerView = FooterView()
            if viewModel.isLastResult {
                footerView.setFooterLabelTitle(text: String.LocalizedKeys.noMoreResultsMsg.localized)
            } else {
                footerView.startLoading()
            }
            return footerView
        }
        return nil
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchFilterModel.page = 1
        viewModel.searchFilterModel.projectName = searchText.isEmpty ? nil : searchText
        configureFilterButton()
        viewModel.fetchPrevProjects()
    }
}

extension SearchViewController: FilterViewControllerDelegate {
    func filterViewControllerDismissed() {
        configureFilterButton()
        viewModel.updateFilter()
        startLoading()
        viewModel.fetchPrevProjects()
    }
}
