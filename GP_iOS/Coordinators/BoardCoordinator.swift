//
//  BoardCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 09/01/2024.
//

import UIKit

class BoardCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: CourseCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    ///  Start the ``BoardCoordinator``
    func start() {
        showBoardViewController()
    }

    private func showBoardViewController() {
        let boardViewController = BoardViewController()
        boardViewController.coordinator = self
        navigationController.pushViewController(boardViewController, animated: true)
    }

    func showTaskViewController(taskModel: TaskModel) {
        let taskViewController = TaskViewController(taskModel: taskModel)
        if let topViewController = navigationController.topViewController as? TaskViewControllerDelegate {
            taskViewController.delegate = topViewController
        }
        taskViewController.modalPresentationStyle = .formSheet
        if let sheetController = taskViewController.presentationController as? UISheetPresentationController {
            sheetController.detents = [.custom { _ in
                return 480
            }]
            sheetController.prefersGrabberVisible = true
        }
        navigationController.present(taskViewController, animated: true)
    }
}
