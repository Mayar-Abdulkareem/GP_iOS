//
//  LoginViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 16/11/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    
    private lazy var registrationIDTextField = {
        let textFieldView = TitleTextFieldView(leftImage: UIImage.SystemImages.number.image)
        textFieldView.textField.placeholder = String.LocalizedKeys.registrationIDTextFieldText.localized
        textFieldView.textField.keyboardType = .numberPad
        textFieldView.textField.delegate = self
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }()
    
    private lazy var passwordTextField = {
        let textFieldView = TitleTextFieldView(leftImage: UIImage.SystemImages.lock.image, isSecureTextEntry: true)
        textFieldView.textField.placeholder = String.LocalizedKeys.passwordTextFieldText.localized
        textFieldView.textField.delegate = self
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }()
    
    private lazy var loginButton = {
        let button = CustomButton(buttonText: String.LocalizedKeys.loginButtonKey.localized)
        button.addAction(UIAction { [weak self] _ in
            self?.loginTapped()
        }, for: .primaryActionTriggered)
        return button
    }()
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myPrimary
        configureViews()
        bindWithViewModel()
    }
    
    private func configureViews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(registrationIDTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        
        stackView.setCustomSpacing(30, after: passwordTextField)
        
        let logoImageView = getImageView(with: UIImage.gradProHorizontal, contentMode: .scaleAspectFit)
        
        let bottomImageView = getImageView(with: UIImage.layeredWaves, contentMode: .scaleToFill)
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        view.addSubview(bottomImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            logoImageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -50),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            bottomImageView.heightAnchor.constraint(equalToConstant: 250),
            bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func getImageView(with image: UIImage, contentMode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = contentMode
        return imageView
    }
    
    private func bindWithViewModel() {
        viewModel.onShowTopAlert = { [weak self] title, subTitle, type in
            AuthManager.shared.userAccessToken = nil
            self?.hideLoading()
            TopAlertManager.show(
                title: title,
                subTitle: subTitle,
                type: type
            )
        }
        
        viewModel.onAuthSuccess = { [weak self] accessToken in
            self?.coordinator?.didFinishAuth()
        }
        
        viewModel.onShowLoading = { [weak self] in
            guard let self else { return }
            showLoading(maskView: view)
        }
    }
    
    private func loginTapped() {
        view.endEditing(true)
        let registrationID = registrationIDTextField.textField.text ?? ""
        let password = passwordTextField.textField.text ?? ""
        viewModel.login(
            with: Credential(
                regID: registrationID,
                password: password
            )
        )
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
