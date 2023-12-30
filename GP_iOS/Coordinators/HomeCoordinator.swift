//
//  HomeCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import UIKit
import SendbirdUIKit

class HomeCoordinator: Coordinator {

    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: TabBarCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    ///  Start the ``HomeCoordinator``
    func start() {
        showHomeFlow()
    }

    private func showHomeFlow() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: false)
    }

    func showCourseViewController(viewModel: HomeViewModel) {
        let courseViewController = CourseViewController()
        courseViewController.viewModel = viewModel
        let navController = UINavigationController(rootViewController: courseViewController)
        navController.modalPresentationStyle = .fullScreen

        let myCoordinator = CourseCoordinator(navigationController: navController)
        childCoordinators.append(myCoordinator)
        myCoordinator.parentCoordinator = self
        courseViewController.coordinator = myCoordinator
        navigationController.present(navController, animated: true)
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
    }

    func presentSendbirdChatInterface() {
        let channelListVC = SBUGroupChannelListViewController()
        let navController = UINavigationController(rootViewController: channelListVC)
        navController.view.tintColor = UIColor.mySecondary
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true)
    }
}
