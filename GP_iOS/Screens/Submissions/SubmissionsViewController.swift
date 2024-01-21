//
//  SubmissionsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 14/12/2023.
//

import UIKit

class SubmissionsViewController: UIViewController, GradProNavigationControllerProtocol {
    weak var coordinator: CourseCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()


    }

    private func configureViews() {
        view.backgroundColor = UIColor.myPrimary

        configureNavBarTitle(title: String.LocalizedKeys.submissionTitle.localized)
        addSeparatorView()
    }
}
