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

    func showPeerFlow() {
        let coordinator = PeerCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func showBoardFlow() {
        let coordinator = BoardCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func showAssignmentsViewController() {
        let assignmentsViewController = AssignmentsViewController()
        assignmentsViewController.coordinator = self
        navigationController.pushViewController(assignmentsViewController, animated: true)
    }

    func showSubmissionsViewController() {
        let submissionViewController = SubmissionViewController()
        navigationController.pushViewController(submissionViewController, animated: true)
    }

    func showRequestsViewController() {
        let requestsViewController = RequestsViewController()
        navigationController.pushViewController(requestsViewController, animated: true)
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
