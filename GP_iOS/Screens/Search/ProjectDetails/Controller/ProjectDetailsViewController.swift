//
//  ProjectDetailsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 18/12/2023.
//

import UIKit

class ProjectDetailsViewController: UIViewController {
    
    private let projectNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .mySecondary
        label.numberOfLines = 0
        return label
    }()
   
    private lazy var projectLinkButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Open The Drive Link"
        configuration.imagePlacement = .all
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if let link = AppManager.shared.prevProject?.link, let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
        }, for: .primaryActionTriggered)
        button.tintColor = UIColor.mySecondary
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        view.backgroundColor = UIColor.myPrimary
        projectNameLabel.text = AppManager.shared.prevProject?.name
        
        view.addSubview(projectNameLabel)
        view.addSubview(stackView)
        view.addSubview(projectLinkButton)
        
        let projectTypeView = LabeledIconView(
            icon: UIImage.SystemImages.projectType.image,
            prefix: "Project Type: ",
            text: AppManager.shared.prevProject?.projectType ?? ""
        )
        let yearView = LabeledIconView(
            icon: UIImage.SystemImages.year.image,
            prefix: "Year: ",
            text: (AppManager.shared.prevProject?.date ?? "")
        )
        let studentsView = LabeledIconView(
            icon: UIImage.SystemImages.choosePeer.image,
            prefix: "Students: ",
            text: (AppManager.shared.prevProject?.students ?? "")
        )
        let supervisorView = LabeledIconView(
            icon: UIImage.SystemImages.supervisor.image,
            prefix: "Supervisor: ",
            text: (AppManager.shared.prevProject?.supervisor ?? "")
        )
        
        stackView.addArrangedSubview(projectTypeView)
        stackView.addArrangedSubview(yearView)
        stackView.addArrangedSubview(studentsView)
        stackView.addArrangedSubview(supervisorView)
        
        NSLayoutConstraint.activate([
            projectNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            projectNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            projectLinkButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            projectLinkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            projectLinkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
        ])
    }
}
