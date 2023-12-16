//
//  PeerViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import UIKit

class PeerViewController: UIViewController {
    weak var coordinator: CourseCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.showDefaultNavigationBar(title: String.LocalizedKeys.choosePeerTitle.localized, withCloseButton: false)
        view.backgroundColor = UIColor.myLightGray

        addConstrainits()
    }
    
    private func addConstrainits() {
        view.subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
