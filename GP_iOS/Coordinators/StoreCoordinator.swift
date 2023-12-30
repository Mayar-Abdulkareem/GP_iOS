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
    var itemDetailsViewController: ItemDetailsViewController?

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

    func presentItemDetailsViewController(viewModel: StoreViewModel) {
        itemDetailsViewController = ItemDetailsViewController(viewModel: viewModel)
        if let itemDetailsViewController {
            if navigationController.viewControllers.first is UITabBarController {
                if let tabBarController = navigationController.viewControllers.first as? UITabBarController {
                    if let storeVC = tabBarController.viewControllers?[TabInfo.store.tag] as? StoreViewController {
                        itemDetailsViewController.delegate = storeVC
                    }
                }

                itemDetailsViewController.modalPresentationStyle = .formSheet
                if let sheetController = itemDetailsViewController.presentationController as? UISheetPresentationController {
                    sheetController.detents = [.custom { _ in
                        return 480
                    }]
                    sheetController.prefersGrabberVisible = true
                }
                navigationController.present(itemDetailsViewController, animated: true)
            }
        }
    }
}
