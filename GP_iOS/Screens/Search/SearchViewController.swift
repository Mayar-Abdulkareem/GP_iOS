//
//  SearchViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    weak var coordinator: SearchCoordinator?
    
    let viewModel = SearchViewModel()
        
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = String.LocalizedKeys.searchTitle.localized
        searchBar.layer.borderWidth = 0
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let filterButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.SystemImages.filter.image
        configuration.imagePlacement = .all
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.gray
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(configureFilterButton), name: NSNotification.Name("ClearNotification"), object: nil)
        bindWithViewModel()
        addViews()
        addConstrainits()
        startActivityIndicator()
        viewModel.fetchPrevProjects(searchFilterModel: viewModel.searchFilterModel)
    }
    
    private func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func addViews() {
        /// Add views to the view
        view.addSubview(searchBar)
        view.addSubview(filterButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        /// Add properities to the view
        view.backgroundColor = UIColor.myPrimary
        activityIndicator.color = .gray
    }
    
    private func addConstrainits() {
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            filterButton.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 44),
            filterButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor)
        ])
    }
    
    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
            self?.stopActivityIndicator()
        }
        
        viewModel.onFetchPrevProjects = { [weak self] prevProjects in
            if self?.viewModel.searchFilterModel.page == 1 {
                self?.viewModel.prevProjects = prevProjects.previousProjects
            } else {
                self?.viewModel.prevProjects += prevProjects.previousProjects
            }
            self?.viewModel.totalPagesCount = prevProjects.totalCount
            self?.stopActivityIndicator()
            if self?.viewModel.prevProjects.count == 0 {
                self?.tableView.setEmptyView(message: String.LocalizedKeys.noPrevProjects.localized)
            } else {
                self?.tableView.removeEmptyView()
            }
            self?.tableView.reloadData()
        }
    }
    
    @objc func configureFilterButton() {
        if viewModel.selectedFilterRows.isEmpty && !viewModel.isSearching {
            filterButton.tintColor = UIColor.gray
            filterButton.configuration?.image = UIImage.SystemImages.filter.image
        } else {
            filterButton.tintColor = UIColor.mySecondary
            filterButton.configuration?.image = UIImage.SystemImages.fiterFill.image
        }
    }
    
    @objc private func filterButtonTapped() {
        coordinator?.presentFilterViewController(with: viewModel)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource  {
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
            
            if (indexPath.row == viewModel.prevProjects.count - 1) && (indexPath.row < (viewModel.totalPagesCount - 1)) {
                /// Check if the current row is the last one and it is loading
                viewModel.isLastResult = false
                viewModel.searchFilterModel.page += 1
                viewModel.fetchPrevProjects(searchFilterModel: viewModel.searchFilterModel)
            } else if (indexPath.row == viewModel.prevProjects.count - 1) && (indexPath.row == viewModel.totalPagesCount - 1) {
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
                footerView.startActivityIndicator()
            }
            return footerView
        }
        return nil
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            /// No text to search, then show all results
            viewModel.searchFilterModel.page = 1
            viewModel.searchFilterModel.projectName = nil
            viewModel.isSearching = false
            configureFilterButton()
            viewModel.fetchPrevProjects(searchFilterModel: viewModel.searchFilterModel)
        } else {
            /// Search and filter the projects based on the project name
            viewModel.searchFilterModel.page = 1
            viewModel.searchFilterModel.projectName = searchText
            viewModel.isSearching = true
            configureFilterButton()
            viewModel.fetchPrevProjects(searchFilterModel: viewModel.searchFilterModel)
        }
    }
}
