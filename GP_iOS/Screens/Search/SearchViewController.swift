//
//  SearchViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit

class SearchViewController: UIViewController {

    private let mainView: UIView = {
        let view = MainView(title: String.LocalizedKeys.searchTitle.localized)
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
