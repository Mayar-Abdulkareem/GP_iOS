//
//  MoreCoordinator.swift
//  GP_iOS
//
//  Created by FTS on 08/12/2023.
//

import UIKit

class MoreCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: TabBarCoordinator?
    var tabBarController: UITabBarController
    
    init(navigationController: UINavigationController, tabBarController: UITabBarController) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
    
    ///  Start the ``MoreCoordinator``
    func start() {
    }
    
    func showProfileViewController() {
        let profileViewController = ProfileViewController()
        
        if let moreNavigationController = tabBarController.viewControllers?[3] as? UINavigationController {
            moreNavigationController.pushViewController(profileViewController, animated: true)
        }
    }
    
    func showRegisterViewController() {
        let registerViewController = RegisterViewController()
        if let moreNavigationController = tabBarController.viewControllers?[3] as? UINavigationController {
            moreNavigationController.pushViewController(registerViewController, animated: true)
        }
    }
    
    func showAnnouncementViewController() {
        let announcementViewController = AnnouncementViewController()
        if let moreNavigationController = tabBarController.viewControllers?[3] as? UINavigationController {
            moreNavigationController.pushViewController(announcementViewController, animated: true)
        }
    }
    
    /// Present the Login screen
    func didLogout() {
        parentCoordinator?.didLogout()
    }
}


