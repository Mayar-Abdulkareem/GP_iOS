//
//  ProjectDescriptionViewController.swift
//  GP_iOS
//
//  Created by FTS on 18/12/2023.
//

import UIKit

class ProjectDescriptionViewController: UIViewController {

    var descriptionText: String?

        private let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            return label
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            updateUI()
        }

        private func setupUI() {
            view.backgroundColor = .white
            title = "Project Description"
            
            view.addSubview(descriptionLabel)

            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ])
        }

        private func updateUI() {
            descriptionLabel.text = descriptionText
        }

}
