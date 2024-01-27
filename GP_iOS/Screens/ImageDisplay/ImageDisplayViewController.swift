//
//  ImageDisplayViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 23/01/2024.
//

import UIKit

class ImageDisplayViewController: UIViewController, GradProNavigationControllerProtocol {

    private let imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary
        view.addViewFillEntireView(imageView)

        addNavBar(with: "")
    }
}
