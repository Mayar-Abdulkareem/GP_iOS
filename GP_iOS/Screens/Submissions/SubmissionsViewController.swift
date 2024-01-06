//
//  SubmissionsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 14/12/2023.
//

import UIKit

class SubmissionsViewController: UIViewController {
    weak var coordinator: CourseCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.myPrimary
        navigationController?.showDefaultNavigationBar(
            title: String.LocalizedKeys.submissionTitle.localized,
            withCloseButton: false
        )
        view.backgroundColor = UIColor.myLightGray
    }
}
