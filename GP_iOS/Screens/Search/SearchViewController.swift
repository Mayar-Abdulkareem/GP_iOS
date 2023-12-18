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
    
    private let mainView: UIView = {
        let view = MainView(title: String.LocalizedKeys.searchTitle.localized)
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private let footerView: FooterView = {
        let view = FooterView()
        //view.setBackgroundColor(color: .clear)
        return view
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
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
        view.addViewFillEntireView(mainView)
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
        view.addSubview(searchBar)
        view.addSubview(filterButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        /// Add properities to the view
        activityIndicator.color = .gray
        tableView.tableFooterView = footerView
        tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
        tableView.tableFooterView?.isHidden = true
        
    }
    
    private func addConstrainits() {
        view.subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        /// Set tableView constraints
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.66),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
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
            self?.viewModel.totalCount = prevProjects.totalCount
            self?.stopActivityIndicator()
            if self?.viewModel.prevProjects.count == 0 {
                self?.tableView.setEmptyView(message: String.LocalizedKeys.noPrevProjects.localized)
                self?.tableView.tableFooterView?.isHidden = true
            } else {
                self?.tableView.tableFooterView?.isHidden = false
                self?.tableView.removeEmptyView()
            }
            self?.tableView.reloadData()
        }
    }
    
    @objc private func filterButtonTapped() {
        coordinator?.presentFilterViewController(with: viewModel)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.prevProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentProject: PreviousProject = viewModel.prevProjects[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell ?? SearchTableViewCell()
        cell.configureCell(
            model: PreviousProject(
                name: currentProject.name,
                projectType: currentProject.projectType,
                date: currentProject.date,
                students: currentProject.students,
                supervisor: "Dr." + currentProject.supervisor,
                description: currentProject.description,
                link: currentProject.link
            )
        )
        
        if (indexPath.row == viewModel.prevProjects.count - 1) && (indexPath.row < (viewModel.totalCount - 1)) {
            /// Check if the current row is the last one and it is loading
            footerView.startActivityIndicator()
            viewModel.searchFilterModel.page += 1
            viewModel.fetchPrevProjects(searchFilterModel: viewModel.searchFilterModel)
        } else if (indexPath.row == viewModel.prevProjects.count - 1) && (indexPath.row == viewModel.totalCount - 1) {
            /// Check if the current row is the last one and there are no more pages
            tableView.tableFooterView = footerView
            footerView.setFooterLabelTitle(text: String.LocalizedKeys.noMoreResultsMsg.localized)
        }
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            /// No text to search, then show all results
            viewModel.searchFilterModel.page = 1
            viewModel.searchFilterModel.projectName = nil
            viewModel.isFiltering = false
            viewModel.fetchPrevProjects(searchFilterModel: viewModel.searchFilterModel)
        } else {
            /// Search and filter the projects based on the project name
            viewModel.searchFilterModel.page = 1
            viewModel.searchFilterModel.projectName = searchText
            viewModel.isFiltering = true
            viewModel.fetchPrevProjects(searchFilterModel: viewModel.searchFilterModel)
        }
    }
}
