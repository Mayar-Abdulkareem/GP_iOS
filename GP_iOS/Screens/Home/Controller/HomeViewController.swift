//
//  HomeViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit
import FHAlert

class HomeViewController: UIViewController {

    private let mainView = HeaderView()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear

        tableView.register(
            HomeTableViewCell.self,
            forCellReuseIdentifier: HomeTableViewCell.identifier
        )

        tableView.register(
            HeaderTableViewCell.self,
            forCellReuseIdentifier: HeaderTableViewCell.identifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    weak var coordinator: HomeCoordinator?
    private var viewModel: HomeViewModelProtocol

    init() {
        switch Role.getRole() {
        case .student:
            viewModel = StudentHomeViewModel()
        case .supervisor:
            viewModel = SupervisorHomeViewModel()
        case .none:
            fatalError()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        bindWithViewModel()
        configureViews()
        startLoading()
        viewModel.getProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hideDefaultNavigationBar()
    }

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

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            self?.stopLoading()
            TopAlertView.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: TopAlertType.failure)
        }

        viewModel.onProfileFetched = { [weak self] noCourses in
            self?.stopLoading()
            if noCourses {
                self?.tableView.setEmptyView(message: String.LocalizedKeys.noCourses.localized)
            } else {
                self?.tableView.removeEmptyView()
            }
            self?.tableView.reloadData()
        }
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary

        view.addSubview(tableView)
        view.addSubview(mainView)

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: tableView.topAnchor),

            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].getTitle()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .header:
            return 1
        case .courses:
            return viewModel.getCount()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .header:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HeaderTableViewCell.identifier,
                for: indexPath
            ) as? HeaderTableViewCell
            cell?.configureCell(
                model: HeaderTableViewCellModel(
                    title: "Welcome \(viewModel.getName())",
                    subtitle: "You're one step closer to graduating on each launch!",
                    image: .project
                )
            )
            return cell ?? UITableViewCell()

        case .courses:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeTableViewCell.identifier,
                for: indexPath
            ) as? HomeTableViewCell

            let cellModel = viewModel.getCellModel(index: indexPath.row)
            cell?.configureCell(model: cellModel)
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .courses = viewModel.sections[indexPath.section] {
            //AppManager.shared.course = viewModel.profile?.courses[indexPath.row]
            viewModel.onCourseTapped(index: indexPath.row)
            coordinator?.showCourseViewController(viewModel: viewModel)
        }
    }
}

extension HomeViewController: HeaderViewControllerDelegate {
    func chatButtonTapped() {
        coordinator?.presentSendbirdChatInterface()
    }
}
