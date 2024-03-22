//
//  MoreCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 08/12/2023.
//

import UIKit

class MoreCoordinator: Coordinator {

    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: TabBarCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.isNavigationBarHidden = true
    }

    ///  Start the ``MoreCoordinator``
    func start() {
    }

    func showProfileViewController() {
        let profileViewController = ProfileViewController()
        let navController = UINavigationController(rootViewController: profileViewController)
        navController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true)
    }

    func showRegisterFlow() {
        let coordinator = RegisterCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }

    func presentSendbirdChatInterface() {
        let channelListVC = SendBirdManager.shared.returnSBUGroupChannelListViewController()
        let navController = UINavigationController(rootViewController: channelListVC)
        navController.view.tintColor = UIColor.mySecondary
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true)
    }

    /// Present the Login screen
    func didLogout() {
        parentCoordinator?.didLogout()
    }
}
