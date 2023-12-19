//
//  ProjectDetailsViewController.swift
//  GP_iOS
//
//  Created by FTS on 18/12/2023.
//

import UIKit

class ProjectDetailsViewController: UIViewController {
    
    private let projectNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let projectTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let studentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let supervisorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let projectLinkButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Open Link"
        configuration.imagePlacement = .all
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(projectLinkButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.mySecondary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
//    private let showMoreButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Show More", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        button.tintColor = .blue
//        button.addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
//        return button
//    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.showDefaultNavigationBar(title: "Project details", withCloseButton: true)
        addViews()
        addConstraints()
        fillLabelsText()
    }
    
    // MARK: - UI Setup
    
    private func addViews() {
        view.backgroundColor = UIColor.myPrimary
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(projectNameLabel)
        stackView.addArrangedSubview(projectTypeLabel)
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(studentsLabel)
        stackView.addArrangedSubview(supervisorLabel)
        stackView.addArrangedSubview(descriptionLabel)
        view.addSubview(projectLinkButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            projectLinkButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            projectLinkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            projectLinkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    private func fillLabelsText() {
        if let selectedPrevProject = AppManager.shared.prevProject {
            projectNameLabel.text = "Project Name: \(selectedPrevProject.name)"
            projectTypeLabel.text = "Project Type: \(selectedPrevProject.projectType)"
            yearLabel.text = "Year: \(selectedPrevProject.date )"
            studentsLabel.text = "Students: \(selectedPrevProject.students)"
            supervisorLabel.text = "Supervisor: \(selectedPrevProject.supervisor)"
            descriptionLabel.text = "Description: \(selectedPrevProject.description)"
        }
    }
    
    @objc private func projectLinkButtonTapped() {
        if let link = AppManager.shared.prevProject?.link, let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
    
//    @objc private func showMoreButtonTapped() {
//        let showMoreVC = ProjectDescriptionViewController()
//        showMoreVC.descriptionText = AppManager.shared.prevProject?.description
//        navigationController?.pushViewController(showMoreVC, animated: true)
//    }
}
