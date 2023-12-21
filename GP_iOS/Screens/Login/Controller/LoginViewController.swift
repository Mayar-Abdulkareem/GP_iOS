//
//  LoginViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 16/11/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    
    private let loginImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.login
        return imageView
    }()
    
    private let loginView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mySecondary.withAlphaComponent(0.8)
        return view
    }()
    
    private let registrationIDTextField = {
        let textField = CustomTextField(withPlaceHolder: String.LocalizedKeys.registrationIDTextFieldText.localized)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let passwordTextField = {
        let textField = CustomTextField(
            withPlaceHolder: String.LocalizedKeys.passwordTextFieldText.localized,
            isPassword: true
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginBackgroundImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.loginBackground
        return imageView
    }()
    
    private let loginButton = CustomButton(buttonText: String.LocalizedKeys.loginButtonKey.localized)
    
    private let togglePasswordButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.SystemImages.slashFillEye.image, for: .normal)
        button.setImage(UIImage.SystemImages.fillEye.image, for: .selected)
        button.tintColor = UIColor.myGray
        return button
    }()
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 70
        stackView.alignment = .fill
        return stackView
    }()
    
    private let welcomeLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String.LocalizedKeys.welcomeMessage.localized
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private let logoView = LogoView(
        symbolImage: UIImage.SystemImages.graduationCap.image,
        logoText: String.LocalizedKeys.logoText.localized
    )
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        addActions()
        bindWithViewModel()
    }
    
    private func configureViews() {
        view.addSubview(loginImageView)
        view.addSubview(loginView)
        view.addSubview(loginBackgroundImageView)
        view.addSubview(logoView)
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(togglePasswordButton)
        
        stackView.addArrangedSubview(registrationIDTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.setCustomSpacing(120, after: passwordTextField)
        
        NSLayoutConstraint.activate([
            loginImageView.topAnchor.constraint(equalTo: view.topAnchor),
            loginImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            loginBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            
            logoView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: loginView.centerYAnchor, constant: 40),
            
            welcomeLabel.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 15),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            togglePasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            togglePasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            togglePasswordButton.widthAnchor.constraint(equalToConstant: 45),
            togglePasswordButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func addActions() {
        togglePasswordButton.addAction(UIAction { [weak self] _ in
            self?.passwordTextField.isSecureTextEntry.toggle()
            self?.togglePasswordButton.isSelected = !(self?.passwordTextField.isSecureTextEntry ?? false)
        }, for: .primaryActionTriggered)
        
        loginButton.addAction(UIAction {
            [weak self] _ in
            guard let self else { return }
            self.showLoading(maskView: view)
            self.viewModel.login(
                with: Credential(
                    regID: self.registrationIDTextField.text ?? "" ,
                    password: self.passwordTextField.text ?? ""
                )
            )
        }, for: .primaryActionTriggered)
    }
    
    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            AuthManager.shared.userAccessToken = nil
            self?.hideLoading()
            if (msg == String.LocalizedKeys.fillAllFieldsMsg.localized) {
                TopAlertManager.show(title: "Info", subTitle: msg, type: .info)
            }
            else {
                TopAlertManager.show(title: "Error", subTitle: msg, type: .failure)
            }
        }
        
        viewModel.onAuthSuccess = { [weak self] accessToken in
            self?.coordinator?.didFinishAuth()
        }
    }
}
