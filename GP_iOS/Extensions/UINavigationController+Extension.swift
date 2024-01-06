//
//  UIViewController+Extension.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 13/12/2023.
//

import UIKit

extension UINavigationController {

    func showDefaultNavigationBar(title: String, withCloseButton: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.mySecondary
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance

        topViewController?.navigationItem.title = title

        navigationBar.tintColor = UIColor.white

        if withCloseButton {
            let closeButton = UIBarButtonItem(
                title: "Close",
                style: .plain,
                target: self,
                action: #selector(closeButtonTapped)
            )
            topViewController?.navigationItem.leftBarButtonItem = closeButton
        }

        isNavigationBarHidden = false
    }

    @objc func closeButtonTapped() {
        // Check if the view controller is presented modally by inspecting if it has a presentingViewController
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else if let navigationController = navigationController {
            // Check if the navigation controller can pop the view controller, which means it's part of a navigation stack
      //      if navigationController.viewControllers.count > 1 {
      //          navigationController.popViewController(animated: true)
     //       } else {
                // If the view controller is the root of the navigation stack, dismiss the whole navigation controller
                navigationController.dismiss(animated: true, completion: nil)
   //         }
        }
    }


    func hideDefaultNavigationBar() {
        isNavigationBarHidden = true
    }
}
