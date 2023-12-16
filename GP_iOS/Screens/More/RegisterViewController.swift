//
//  RegisterViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/11/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    weak var coordinator: CourseCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.showDefaultNavigationBar(title: String.LocalizedKeys.registerTitle.localized, withCloseButton: true)
        view.backgroundColor = UIColor.myLightGray
        
        addConstrainits()
    }
    
    private func addConstrainits() {
        view.subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
