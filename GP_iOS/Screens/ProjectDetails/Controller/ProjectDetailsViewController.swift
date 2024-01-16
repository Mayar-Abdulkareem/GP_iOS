//
//  ProjectDetailsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 18/12/2023.
//

import UIKit

class ProjectDetailsViewController: UIViewController, GradProNavigationControllerProtocol {

    private lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .primary,
            primaryButtonTitle: String.LocalizedKeys.driveLink.localized,
            secondaryButtonType: .disabled,
            secondaryButtonTitle: nil
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
        return footerView
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

        addNavBar(with: AppManager.shared.prevProject?.name)
        addNavCloseButton()

        view.addSubview(stackView)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func configureStackView() {
        let projectTypeView = LabelIconView(
            icon: UIImage.SystemImages.projectType.image,
            prefix: String.LocalizedKeys.projectType.localized + " ",
            text: AppManager.shared.prevProject?.projectType ?? "",
            imageSize: 30
        )
        let yearView = LabelIconView(
            icon: UIImage.SystemImages.year.image,
            prefix: String.LocalizedKeys.year.localized + " ",
            text: (AppManager.shared.prevProject?.date ?? ""),
            imageSize: 30
        )
        let studentsView = LabelIconView(
            icon: UIImage.SystemImages.choosePeer.image,
            prefix: String.LocalizedKeys.studentsTitle.localized + " ",
            text: (AppManager.shared.prevProject?.students ?? ""),
            imageSize: 30
        )
        let supervisorView = LabelIconView(
            icon: UIImage.SystemImages.supervisor.image,
            prefix: String.LocalizedKeys.supervisorTitle.localized,
            text: (AppManager.shared.prevProject?.supervisor ?? ""),
            imageSize: 30
        )

        stackView.addArrangedSubview(projectTypeView)
        stackView.addArrangedSubview(yearView)
        stackView.addArrangedSubview(studentsView)
        stackView.addArrangedSubview(supervisorView)
    }
}

extension ProjectDetailsViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        if let link = AppManager.shared.prevProject?.link, let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}
