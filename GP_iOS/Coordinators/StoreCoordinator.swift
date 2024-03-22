//
//  StoreCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 24/12/2023.
//

import UIKit

class StoreCoordinator: Coordinator {

    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: TabBarCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    ///  Start the ``StoreCoordinator``
    func start() {
        showStoreViewController()
    }

    /// Present the ``StoreViewController``
    private func showStoreViewController() {
        let storeViewController = StoreViewController()
        storeViewController.coordinator = self
        navigationController.pushViewController(storeViewController, animated: false)
    }
}
