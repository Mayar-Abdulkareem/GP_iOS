//
//  SearchCoordinator.swift
//  GP_iOS
//
//  Created by FTS on 17/12/2023.
//

import UIKit

class SearchCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: TabBarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    ///  Start the ``SearchCoordinator``
    func start() {
        showSearchViewController()
    }
    
    /// Present the ``SearchViewController``
    private func showSearchViewController() {
        let searchViewController = SearchViewController()
        searchViewController.coordinator = self
        navigationController.pushViewController(searchViewController, animated: false)
    }
    
    func presentFilterViewController(with viewModel: SearchViewModel?) {
        guard let viewModel = viewModel else {return}
        let filterViewController = FilterViewController(viewModel: viewModel)
        if navigationController.viewControllers.first is UITabBarController {            
            if let tabBarController = navigationController.viewControllers.first as? UITabBarController {
                if let searchViewController = tabBarController.viewControllers?[TabInfo.search.tag] as? SearchViewController {
                    filterViewController.delegate = searchViewController
                }
            }
        }
        let navController = UINavigationController(rootViewController: filterViewController)
        navigationController.present(navController, animated: true)
    }
    
    func presentProjectDetailsViewController() {
        let projectDetailsViewController = ProjectDetailsViewController()
        
        projectDetailsViewController.modalPresentationStyle = .formSheet
        if let sheetPresentationController = projectDetailsViewController.presentationController as? UISheetPresentationController {
//            sheetPresentationController.detents = [.custom { context in
//                return context.maximumDetentValue * 0.45
//            }]
            sheetPresentationController.detents = [.custom { _ in
                return 300
            }]
            sheetPresentationController.prefersGrabberVisible = true
        }
        
        navigationController.present(projectDetailsViewController, animated: true)
    }
}