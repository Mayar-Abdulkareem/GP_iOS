//
//  MoreViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit

class MoreViewController: UIViewController {
    weak var coordinator: MoreCoordinator?
    
    private let moreCellModel = [
        MoreCellModel(title: String.LocalizedKeys.profileTitle.localized, icon: UIImage.SystemImages.profile.image),
        MoreCellModel(title: String.LocalizedKeys.registerTitle.localized, icon: UIImage.SystemImages.register.image),
        MoreCellModel(title: String.LocalizedKeys.announcementTitle.localized, icon: UIImage.SystemImages.announcement.image),
        MoreCellModel(title: String.LocalizedKeys.logoutTitle.localized, icon: UIImage.SystemImages.logout.image)
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        return tableView
    }()

    private let mainView: UIView = {
        let view = MainView(title: String.LocalizedKeys.moreTitle.localized)
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MoreTableViewCell.self, forCellReuseIdentifier: MoreTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        addViews()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hideDefaultNavigationBar()
    }
    
    private func addViews() {
        view.addViewFillEntireView(mainView)
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        view.subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        /// Set tableView constraints
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreCellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.identifier, for: indexPath) as? MoreTableViewCell
        guard let cell = cell else {
            return UITableViewCell()
        }
        cell.configureCell(model: moreCellModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            coordinator?.showProfileViewController()
        case 1:
            coordinator?.showRegisterViewController()
        case 2:
            coordinator?.showAnnouncementViewController()
        default:
            coordinator?.didLogout()
        }
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}
