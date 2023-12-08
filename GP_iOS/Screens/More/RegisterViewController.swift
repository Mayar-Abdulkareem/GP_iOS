//
//  RegisterViewController.swift
//  GP_iOS
//
//  Created by FTS on 28/11/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let mainView: UIView = {
        let view = MainView(title: String.LocalizedKeys.registerTitle.localized)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addViewFillEntireView(mainView)
        addConstrainits()
    }
    
    private func addConstrainits() {
        view.subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
