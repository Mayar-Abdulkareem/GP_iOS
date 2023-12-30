//
//  ProfileViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/11/2023.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.showDefaultNavigationBar(
            title: String.LocalizedKeys.profileTitle.localized,
            withCloseButton: true
        )
        view.backgroundColor = UIColor.myLightGray
    }
}
