//
//  ProjectDetailsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 18/12/2023.
//

import UIKit

class ProjectDetailsViewController: UIViewController {

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale).isActive = true
        return view
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
        stackView.distribution = .fillProportionally
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureStackView()
    }

    private func configureViews() {
        view.backgroundColor = UIColor.myPrimary
        
        configureNavBarTitle(title: AppManager.shared.prevProject?.name)
        addNavCloseButton()

        view.addSubview(separatorView)
        view.addSubview(stackView)
        view.addSubview(projectLinkButton)

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            projectLinkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            projectLinkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            projectLinkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureNavBarTitle(title: String?) {
        self.title = title
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.mySecondary,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func addNavCloseButton() {
        let closeButton = UIBarButtonItem(
            title: "Close",
            primaryAction: UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            }
        )
        closeButton.tintColor = UIColor.mySecondary
        navigationItem.leftBarButtonItem = closeButton
    }

    private func configureStackView() {
        let projectTypeView = LabelIconView(
            icon: UIImage.SystemImages.projectType.image,
            prefix: "Project Type: ",
            text: AppManager.shared.prevProject?.projectType ?? "",
            imageSize: 30
        )
        let yearView = LabelIconView(
            icon: UIImage.SystemImages.year.image,
            prefix: "Year: ",
            text: (AppManager.shared.prevProject?.date ?? ""),
            imageSize: 30
        )
        let studentsView = LabelIconView(
            icon: UIImage.SystemImages.choosePeer.image,
            prefix: "Students: ",
            text: (AppManager.shared.prevProject?.students ?? ""),
            imageSize: 30
        )
        let supervisorView = LabelIconView(
            icon: UIImage.SystemImages.supervisor.image,
            prefix: "Supervisor: ",
            text: (AppManager.shared.prevProject?.supervisor ?? ""),
            imageSize: 30
        )

        stackView.addArrangedSubview(projectTypeView)
        stackView.addArrangedSubview(yearView)
        stackView.addArrangedSubview(studentsView)
        stackView.addArrangedSubview(supervisorView)
    }
}
