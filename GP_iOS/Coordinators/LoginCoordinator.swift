//
//  LoginCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 05/11/2023.
//

import UIKit

class LoginCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    ///  Start the ``LoginCoordinator``
    func start() {
        showLoginViewController()
    }
    
    /// Present the ``LoginVC``
    private func showLoginViewController() {
        let destVC = LoginVC()
        destVC.coordinator = self
        navigationController.pushViewController(destVC, animated: false)
    }
}
