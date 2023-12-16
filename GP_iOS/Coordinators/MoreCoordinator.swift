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
    
    func showRegisterViewController() {
        let registerViewController = RegisterViewController()
        let navController = UINavigationController(rootViewController: registerViewController)
        navController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true)
    }
    
    func showAnnouncementViewController() {
        let announcementViewController = AnnouncementViewController()
        let navController = UINavigationController(rootViewController: announcementViewController)
        navController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true)
    }
    
    /// Present the Login screen
    func didLogout() {
        parentCoordinator?.didLogout()
    }
}


