//
//  LoginCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 05/11/2023.
//

import UIKit

class LoginCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    ///  Start the ``LoginCoordinator``
    func start() {
        showLoginViewController()
    }
    
    /// Present the ``LoginVC``
    private func showLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        navigationController.pushViewController(loginViewController, animated: false)
    }

    /// Present the home screen
    func didFinishAuth() {
        parentCoordinator?.didFinishAuth()
    }
}
