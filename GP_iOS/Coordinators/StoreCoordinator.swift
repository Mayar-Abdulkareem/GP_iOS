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
                    if let storeViewController = tabBarController.viewControllers?[TabInfo.store.tag] as? StoreViewController {
                        itemDetailsViewController.delegate = storeViewController
                    }
                }
                
                itemDetailsViewController.modalPresentationStyle = .formSheet
                if let sheetController = itemDetailsViewController.presentationController as? UISheetPresentationController {
                    sheetController.detents = [.custom { [weak self] _ in
                        return 480
                    }]
                    sheetController.prefersGrabberVisible = true
                }
                navigationController.present(itemDetailsViewController, animated: true)
            }
        }
    }
    
//    func expandItemDetailsSheet() {
//        guard let sheetController = itemDetailsViewController?.presentationController as? UISheetPresentationController else {
//            return
//        }
//        sheetController.detents = [.custom { [weak self] _ in
//            return 550
//        }]
//        //sheetController.detents = [.large()]
//    }
}

