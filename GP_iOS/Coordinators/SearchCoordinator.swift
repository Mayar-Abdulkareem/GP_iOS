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
    
    func presentFilterViewController(with viewModel: SearchViewModel) {
        let filterViewController = FilterViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: filterViewController)
        //navController.modalPresentationStyle = .popover
        navigationController.present(navController, animated: true)
    }
}

