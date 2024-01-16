//
//  PeerCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 14/01/2024.
//

import UIKit

class PeerCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: CourseCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    ///  Start the ``BoardCoordinator``
    func start() {
        shoPeerViewController()
    }

    private func shoPeerViewController() {
        let peerViewController = PeerViewController()
        peerViewController.coordinator = self
        navigationController.pushViewController(peerViewController, animated: true)
    }

    func showSelectPeerViewController() {
        let selectPeerViewController = SelectPeerViewController()
        if let topViewController = navigationController.topViewController as? PeerViewController {
            selectPeerViewController.delegate = topViewController
        }
        let navController = UINavigationController(rootViewController: selectPeerViewController)
        navigationController.present(navController, animated: true)
    }

    func showMatchingPeerViewController() {

        let peerMatchingViewController = PeerMatchingViewController()
        //        if let topViewController = navigationController.topViewController as? PeerViewController {
        //            matchingPeerPeerViewController.delegate = topViewController
        //        }
        let navController = UINavigationController(rootViewController: peerMatchingViewController)
        navigationController.present(navController, animated: true)
        //   }
    }
}
