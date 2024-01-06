//
//  BoardViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import UIKit

class BoardViewController: UIViewController {
    weak var coordinator: CourseCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.myPrimary
        navigationController?.showDefaultNavigationBar(
            title: String.LocalizedKeys.boardTitle.localized,
            withCloseButton: false
        )
        view.backgroundColor = UIColor.myLightGray
    }
}
