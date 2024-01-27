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
    var peerMatchingNavController: UINavigationController?

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
        peerMatchingViewController.coordinator = self
        peerMatchingNavController = UINavigationController(rootViewController: peerMatchingViewController)
        guard let navController = peerMatchingNavController else { return }
        navigationController.present(navController, animated: true)
    }

    func showSkillsViewController(categories: [Category], context: SkillsViewType, delegate: SkillsViewControllerProtocol) {
        guard let peerMatchingNavController = peerMatchingNavController else { return }
        let skillsViewController = SkillsViewController(categories: categories, context: context)
        skillsViewController.delegate = delegate
        peerMatchingNavController.pushViewController(skillsViewController, animated: true)
    }

    func showTopMatchedViewController(topMatchedStudents: [Peer]) {
        guard let peerMatchingNavController = peerMatchingNavController else { return }
        let topMatchedViewController = TopMatchedViewController(topMatchedStudents: topMatchedStudents)
        peerMatchingNavController.pushViewController(topMatchedViewController, animated: true)
    }
}
