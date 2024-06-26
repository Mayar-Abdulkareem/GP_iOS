//
//  MoreViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit

class MoreViewController: UIViewController {
    weak var coordinator: MoreCoordinator?

    private var moreCellModel: [MoreCellModel] {
        switch Role.getRole() {
        case .student:
            var cells = [
                MoreCellModel(
                    title: String.LocalizedKeys.profileTitle.localized,
                    icon: UIImage.SystemImages.profile.image
                ),
                MoreCellModel(
                    title: String.LocalizedKeys.registerTitle.localized,
                    icon: UIImage.SystemImages.register.image
                ),
                MoreCellModel(
                    title: String.LocalizedKeys.logoutTitle.localized,
                    icon: UIImage.SystemImages.logout.image
                ),
            ]
            if AppManager.shared.profile?.registrationFinished ?? false {
                cells.remove(at: 1)
            }
            return cells
        case .supervisor:
            return [
                MoreCellModel(
                    title: String.LocalizedKeys.profileTitle.localized,
                    icon: UIImage.SystemImages.profile.image
                ),
                MoreCellModel(
                    title: String.LocalizedKeys.logoutTitle.localized,
                    icon: UIImage.SystemImages.logout.image
                ),
            ]
        case .none:
            fatalError()
        }
    }
//        MoreCellModel(
//            title: String.LocalizedKeys.profileTitle.localized,
//            icon: UIImage.SystemImages.profile.image
//        ),
//        MoreCellModel(
//            title: String.LocalizedKeys.registerTitle.localized,
//            icon: UIImage.SystemImages.register.image
//        ),
//        MoreCellModel(
//            title: String.LocalizedKeys.logoutTitle.localized,
//            icon: UIImage.SystemImages.logout.image
//        ),
        //        MoreCellModel(
        //            title: "Students",
        //            icon: UIImage.SystemImages.logout.image
        //        ),
        //        MoreCellModel(
        //            title: "Coueses",
        //            icon: UIImage.SystemImages.logout.image
        //        ),
        //        MoreCellModel(
        //            title: "Professors",
        //            icon: UIImage.SystemImages.logout.image
        //        ),
        //        MoreCellModel(
        //            title: "Assigments",
        //            icon: UIImage.SystemImages.logout.image
        //        ),

//    ]}

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)

        tableView.register(
            MoreTableViewCell.self,
            forCellReuseIdentifier: MoreTableViewCell.identifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private lazy var mainView: UIView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hideDefaultNavigationBar()
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary
        view.addSubview(mainView)
        view.addSubview(tableView)

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

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreCellModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MoreTableViewCell.identifier,
            for: indexPath
        ) as? MoreTableViewCell
        guard let cell = cell else {
            return UITableViewCell()
        }
        cell.configureCell(model: moreCellModel[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = moreCellModel[indexPath.row]

            switch selectedItem.title {
            case String.LocalizedKeys.profileTitle.localized:
                coordinator?.showProfileViewController()
            case String.LocalizedKeys.registerTitle.localized:
                coordinator?.showRegisterFlow()
            case String.LocalizedKeys.logoutTitle.localized:
                coordinator?.didLogout()
            default:
                break 
            }
//        case 3:
//            let vc = AdminStudentsViewController()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.modalPresentationStyle = .fullScreen
//            present(navController, animated: true)
//        case 4:
//            let vc = AdminCoursesViewController()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.modalPresentationStyle = .fullScreen
//            present(navController, animated: true)
//
//        case 5:
//            let vc = AdminProfessorsViewController()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.modalPresentationStyle = .fullScreen
//            present(navController, animated: true)
//
//        case 6:
//            let vc = AdminAssigmentViewController()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.modalPresentationStyle = .fullScreen
//            present(navController, animated: true)

//        default:
//            break
//        }
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}

extension MoreViewController: HeaderViewControllerDelegate {
    func chatButtonTapped() {
        coordinator?.presentSendbirdChatInterface()
    }
}
