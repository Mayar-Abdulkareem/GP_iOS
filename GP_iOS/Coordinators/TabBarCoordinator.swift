//
//  TabBarCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit

class TabBarCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    ///  Start the ``TabBarCoordinator``
    func start() {
        showTabBarController()
    }

    /// Present the  tab bar controller
    private func showTabBarController() {
        
        let tabBarController = UITabBarController()
        
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        childCoordinators.append(homeCoordinator)
        
        let homeViewController = HomeViewController()
        homeViewController.coordinator = homeCoordinator
        homeViewController.tabBarItem = TabInfo.home.createTabBarItem()
        
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = TabInfo.search.createTabBarItem()
        
        let storeViewController = StoreViewController()
        storeViewController.tabBarItem = TabInfo.store.createTabBarItem()
        
        let moreCoordinator = MoreCoordinator(navigationController: navigationController)
        moreCoordinator.parentCoordinator = self
        childCoordinators.append(moreCoordinator)
        
        let moreViewController = MoreViewController()
        moreViewController.tabBarItem = TabInfo.more.createTabBarItem()
        moreViewController.coordinator = moreCoordinator
        
        tabBarController.viewControllers = [
            homeViewController,
            searchViewController,
            storeViewController,
            moreViewController
        ]
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    /// Present the Login screen
    func didLogout() {
        parentCoordinator?.didLogout()
    }
}
