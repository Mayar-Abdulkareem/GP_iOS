//
//  MainCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 05/11/2023.
//

import UIKit

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
        showLoginFlow()
    }
    
    ///  Start ``LoginCordinator`` to present the Login page
    private func showLoginFlow() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
