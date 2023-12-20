//
//  MainCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 05/11/2023.
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
        if AuthManager.shared.isUserAuthenticated {
            showHomeFlow()
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
    
    /// Start ``TabBarCoordinator``  to present the Home page
    func showHomeFlow() {
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
        
        UIView.transition(with: navigationController.view,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: {
            
            self.showHomeFlow()
        })
    }
    
    /// Handles the necessary actions when the user logs out.
    func didLogout() {
        // Clear the navigation stack to ensure a clean state.
        navigationController.setViewControllers([], animated: false)
        childCoordinators.removeAll()
        AuthManager.shared.userAccessToken = nil
        AuthManager.shared.regID = nil
        AuthManager.shared.role = nil
        
        UIView.transition(with: navigationController.view,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: {
            self.showLoginFlow()
        })
    }
}
