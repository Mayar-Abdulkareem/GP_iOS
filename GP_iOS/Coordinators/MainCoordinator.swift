//
//  MainCoordinator.swift
//  GP_iOS
//
//  Created by FTS on 05/11/2023.
//

import UIKit

protocol MainCoordinatorProtocol{
    func didFinishAuth()
    func didLogout()
}

/// The initial coordinator that decide which ViewController will will be shown first
class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    /// - Parameter navigationController: Used for managing the hierarchy
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    /// which screen will be shown first
    func start() {
        //AuthManager.shared.userAccessToken = nil
        //print(AuthManager.shared.userAccessToken)
        if AuthManager.shared.isUserAuthenticated {
            showTabBarFlow()
        } else {
            showLoginFlow()
        }
    }
    
    ///  Start ``LoginCordinator`` to present the Login page
    private func showLoginFlow() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    /// Start ``TabBarCoordinator``  to present the Login page
    func showTabBarFlow() {
        let coordinator = TabBarCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension MainCoordinator: MainCoordinatorProtocol {
    
    /// Handles the necessary actions after the user has completed the authentication process.
    /// This method clears the  navigation stack
    func didFinishAuth() {
        /// Clear the navigation stack
        navigationController.setViewControllers([], animated: false)
        childCoordinators.removeAll()
        showTabBarFlow()
    }
    
    /// Handles the necessary actions when the user logs out.
    func didLogout() {
        // Clear the navigation stack to ensure a clean state.
        navigationController.setViewControllers([], animated: false)
        childCoordinators.removeAll()
        AuthManager.shared.userAccessToken = nil
        showLoginFlow()
    }
}
