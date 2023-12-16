//
//  CourseCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/12/2023.
//

import UIKit

class CourseCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: HomeCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    ///  Start the ``CourseCoordinator``
    func start() {
        showCourseViewController()
    }
    
    private func showCourseViewController() {
        let courseViewController = CourseViewController()
        courseViewController.coordinator = self
        navigationController.pushViewController(courseViewController, animated: true)
    }
    
    func showPeerViewController() {
        let peerViewController = PeerViewController()
        peerViewController.coordinator = self
        navigationController.pushViewController(peerViewController, animated: true)
    }
    
    func showBoardViewController() {
        let boardViewController = BoardViewController()
        boardViewController.coordinator = self
        navigationController.pushViewController(boardViewController, animated: true)
    }
    
    func showSubmissionsViewController() {
        let submissionsViewController = SubmissionsViewController()
        submissionsViewController.coordinator = self
        navigationController.pushViewController(submissionsViewController, animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
