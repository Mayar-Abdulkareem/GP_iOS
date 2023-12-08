//
//  TabBarCoordinator.swift
//  GP_iOS
//
//  Created by FTS on 27/11/2023.
//

import UIKit

enum TabInfo {
    case home
    case search
    case store
    case more
    
    var localizedTitle: String {
        switch self {
        case .home: return String.LocalizedKeys.homeTitle.localized
        case .search: return String.LocalizedKeys.searchTitle.localized
        case .store: return String.LocalizedKeys.storeTitle.localized
        case .more: return String.LocalizedKeys.moreTitle.localized
        }
    }
    
    var systemImage: UIImage {
        switch self {
        case .home: return UIImage.SystemImages.home.image
        case .search: return UIImage.SystemImages.search.image
        case .store: return UIImage.SystemImages.store.image
        case .more: return UIImage.SystemImages.more.image
        }
    }
    
    var tag: Int {
        switch self {
        case .home: return 0
        case .search: return 1
        case .store: return 2
        case .more: return 3
        }
    }
    
    func createTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: localizedTitle,
            image: systemImage,
            tag: tag
        )
    }
}

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
        
        // Create and configure tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor.mySecondary
        tabBarController.tabBar.backgroundColor = UIColor.myPrimary
        
        // Create view controllers for each tab
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = TabInfo.home.createTabBarItem()
        
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = TabInfo.search.createTabBarItem()
        
        let storeViewController = StoreViewController()
        storeViewController.tabBarItem = TabInfo.store.createTabBarItem()
        
        let moreCoordinator = MoreCoordinator(navigationController: navigationController, tabBarController: tabBarController)
        moreCoordinator.parentCoordinator = self
        childCoordinators.append(moreCoordinator)
        
        let moreViewController = MoreViewController()
        moreViewController.tabBarItem = TabInfo.more.createTabBarItem()
        moreViewController.coordinator = moreCoordinator
        
        let moreNavigationController = UINavigationController(rootViewController: moreViewController)
        moreNavigationController.navigationBar.tintColor = UIColor.myPrimary
        
        // Add view controllers to the tab bar controller
        tabBarController.viewControllers = [
            homeViewController,
            searchViewController,
            storeViewController,
            moreNavigationController
        ]
        
        let separatorLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBarController.tabBar.frame.width, height: 0.5))
        separatorLine.backgroundColor = .lightGray
        tabBarController.tabBar.addSubview(separatorLine)

        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    /// Present the Login screen
    func didLogout() {
        parentCoordinator?.didLogout()
    }
}

