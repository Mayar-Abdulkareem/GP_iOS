//
//  LoginViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 16/11/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    private var timer: Timer?
    private var loginImageIndex = 0
    private var loginImages = [UIImage]()
    
    private let loginView = UIView()
    private let registrationIDTextField = CustomTextField(withPlaceHolder: "Enter your registration number")
    private let passwordTextField = CustomTextField(withPlaceHolder: "Enter your password")
    private let loginButton = CustomButton(buttonText: "LOGIN")
    private let loginImageView = UIImageView()
    private let togglePasswordButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connfigureUI()
        loginButton.addAction(UIAction { [weak self] _ in
            TopAlertManager.show(title: "error", subTitle: "anything", type: .info)
        }, for: .primaryActionTriggered)
    }
    
    /// Configure the UI of the login screen
    private func connfigureUI() {
        configureLoginImages()
        configureLoginView()
        configureLoginBackground()
        configureLoginLabel()
        configureLoginWelcomeMessageLabel()
        configureLoginForm()
        configureTogglePassword()
    }
    
    /// Configure the  loginImage and its constraints
    private func configureLoginImages() {
        
        // MARK: properities
        loginImageView.translatesAutoresizingMaskIntoConstraints = false
        loginImageView.image = UIImage(named: .loginImage)
        view.addSubview(loginImageView)
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            loginImageView.topAnchor.constraint(equalTo: view.topAnchor),
            loginImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    /// Configure the loginView and its constraints
    private func configureLoginView() {
        
        // MARK: properities
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.backgroundColor = UIColor(named: .secondary).withAlphaComponent(0.8)
        view.addSubview(loginView)
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    /// Configure the loginBackground and its constraints
    private func configureLoginBackground() {
        
        let loginBackground = UIImageView()
        
        // MARK: properities
        loginBackground.translatesAutoresizingMaskIntoConstraints = false
        loginBackground.image = UIImage(named: .loginBackground)

        view.addSubview(loginBackground)
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            loginBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75)
        ])
    }
    
    /// Configure the logo and its constraints
    private func configureLoginLabel() {
        
        let logoLabel = LogoView(symbolName: "book", logoText: "NNU")
        logoLabel.backgroundColor = .black
        
        // MARK: properities
        view.addSubview(logoLabel)
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: loginView.centerYAnchor, constant: 40)
        ])
    }
    
    /// Configure the loginBackground and its constraints
    private func configureLoginWelcomeMessageLabel() {
        
        let welcomeLabel = UILabel()
        
        // MARK: properities
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "Welcome to GradPro!\nLogin Today, Graduate Tomorrow"
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .black
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        view.addSubview(welcomeLabel)
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 15),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    /// Configure the login form and its constraints
    private func configureLoginForm() {
        
        let stackView = UIStackView(arrangedSubviews: [registrationIDTextField, passwordTextField, loginButton])
                
        // MARK: properities
        registrationIDTextField.keyboardType = .numberPad
        passwordTextField.isSecureTextEntry = true
        
        stackView.axis = .vertical
        stackView.spacing = 70
        stackView.setCustomSpacing(120, after: passwordTextField)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        
        view.addSubview(stackView)
                
        // MARK: Constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    /// Configure togglePasswordButton and its constrainnts
    private func configureTogglePassword() {
        
        // MARK: Properities
        togglePasswordButton.setImage(UIImage.SystemImages.slashFillEye.image, for: .normal)
        togglePasswordButton.setImage(UIImage.SystemImages.fillEye.image, for: .selected)
        togglePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        togglePasswordButton.tintColor = UIColor(named: .gray)
        
        view.addSubview(togglePasswordButton)
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            togglePasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            togglePasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            togglePasswordButton.widthAnchor.constraint(equalToConstant: 45),
            togglePasswordButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    /// Handle the toggle password event
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        togglePasswordButton.isSelected = !passwordTextField.isSecureTextEntry
    }
}
