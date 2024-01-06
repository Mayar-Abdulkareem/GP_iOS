//
//  AnnouncementViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/11/2023.
//

import UIKit

class AnnouncementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.showDefaultNavigationBar(
            title: String.LocalizedKeys.announcementTitle.localized,
            withCloseButton: true
        )
        view.backgroundColor = UIColor.myLightGray
    }
}
