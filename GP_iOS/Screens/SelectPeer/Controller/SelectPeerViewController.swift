//
//  SelectPeerViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 14/01/2024.
//

import UIKit

protocol SelectPeerViewControllerDelegate: AnyObject {
    func sendRequest(peerID: String)
}

class SelectPeerViewController: UIViewController, GradProNavigationControllerProtocol {

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Please enter your peer registration number"
        textField.tintColor = .mySecondary
        textField.borderStyle = .roundedRect

        textField.delegate = self

        return textField
    }()

    private let footerView = FooterButtonView(
        primaryButtonType: .disabled,
        primaryButtonTitle: String.LocalizedKeys.sendRequestButtonTitle.localized,
        secondaryButtonType: .disabled,
        secondaryButtonTitle: nil
    )

    weak var delegate: SelectPeerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary

        addNavBar(with: "Select Peer")
        footerView.delegate = self

        view.addSubview(textField)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension SelectPeerViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        guard let peerID = textField.text else { return }
        dismiss(animated: true)
        delegate?.sendRequest(peerID: peerID)
    }
}

extension SelectPeerViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            footerView.changePrimaryButtonType(type: .primary)
        } else {
            footerView.changePrimaryButtonType(type: .disabled)
        }
    }
}
