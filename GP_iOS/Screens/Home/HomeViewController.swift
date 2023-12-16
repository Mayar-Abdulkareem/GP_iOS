//
//  HomeViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    private var courses = [Course]()
    private var viewModel = CoursesViewModel()

    private let mainView: UIView = {
        let view = MainView(title: String.LocalizedKeys.homeTitle.localized)
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addViewFillEntireView(mainView)
        bindWithViewModel()
        addViews()
        addConstrainits()
        startActivityIndicator()
        fetchCourses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hideDefaultNavigationBar()
    }
    
    private func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            print("Error!")
            self?.stopActivityIndicator()
        }
        
        viewModel.onFetchCourses = { [weak self] courses in
            self?.courses = courses
            self?.stopActivityIndicator()
            if courses.count == 0 {
                self?.tableView.setEmptyView(message: String.LocalizedKeys.noCourses.localized)
            } else {
                self?.tableView.removeEmptyView()
            }
            self?.tableView.reloadData()
        }
    }
    
    private func fetchCourses() {
        if let regID = AuthManager.shared.regID {
            viewModel.fetchCourses(with: regID)
        }
    }
    
    private func addViews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        activityIndicator.color = .gray
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
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell
        guard let cell = cell else {
            return UITableViewCell()
        }
        let courseName = courses[indexPath.row].courseName
        let supervisor = "Dr. " + courses[indexPath.row].supervisorName
        cell.configureCell(model: HomeTableViewCellModel(name: courseName, supervisor: supervisor))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppManager.shared.course = courses[indexPath.row]
        coordinator?.showCourseViewController()
    }
}
