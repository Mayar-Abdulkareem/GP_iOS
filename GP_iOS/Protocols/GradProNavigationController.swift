//
//  GradProNavigationController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 16/01/2024.
//

import UIKit

protocol GradProNavigationControllerProtocol: AnyObject {
    func configureNavBarTitle(title: String?)
    func addNavCloseButton()
    func addSeparatorView()
}

extension GradProNavigationControllerProtocol where Self: UIViewController {

    func configureNavBarTitle(title: String?) {
        self.title = title
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.mySecondary,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .mySecondary
    }

    func addNavCloseButton() {
        let closeButton = UIBarButtonItem(
            title: String.LocalizedKeys.closeTitle.localized,
            primaryAction: UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            }
        )
        closeButton.tintColor = UIColor.mySecondary
        navigationItem.leftBarButtonItem = closeButton
    }

    func addSeparatorView() {
        lazy var separatorView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .separator
            view.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale).isActive = true
            return view
        }()

        view.addSubview(separatorView)

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -1/UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func addNavBar(with title: String?) {
        configureNavBarTitle(title: title)
        addNavCloseButton()
        addSeparatorView()
    }
}
