//
//  LoginViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 16/11/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    
    private let loginImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .login)
        return imageView
    }()
    
    private let loginView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .secondary).withAlphaComponent(0.8)
        return view
    }()
    
    private let registrationIDTextField = {
        let textField = CustomTextField(withPlaceHolder: String.LocalizedKeys.registrationIDTextFieldText.localized)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let passwordTextField = {
        let textField = CustomTextField(withPlaceHolder: String.LocalizedKeys.passwordTextFieldText.localized)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginBackgroundImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .loginBackground)
        return imageView
    }()
    
    private let loginButton = CustomButton(buttonText: String.LocalizedKeys.loginButtonKey.localized)
    
    private let togglePasswordButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.SystemImages.slashFillEye.image, for: .normal)
        button.setImage(UIImage.SystemImages.fillEye.image, for: .selected)
        button.tintColor = UIColor(resource: .gray)
        return button
    }()
    
    let stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 70
        stackView.alignment = .fill
        return stackView
    }()
    
    let welcomeLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String.LocalizedKeys.welcomeMessage.localized
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    let logoView = LogoView(
        symbolImage: UIImage.SystemImages.graduationCap.image,
        logoText: String.LocalizedKeys.logoText.localized
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addProperties()
        addConstraints()
        // or configureUI()
    }
    
    private func addViews() {
        view.addSubview(loginImageView)
        view.addSubview(loginView)
        view.addSubview(loginBackgroundImageView)
        view.addSubview(logoView)
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(togglePasswordButton)
    }
    
    private func addProperties() {
        stackView.addArrangedSubview(registrationIDTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.setCustomSpacing(120, after: passwordTextField)
        
        togglePasswordButton.addAction(UIAction { [weak self] _ in
            self?.passwordTextField.isSecureTextEntry.toggle()
            self?.togglePasswordButton.isSelected = !(self?.passwordTextField.isSecureTextEntry ?? false)
        }, for: .primaryActionTriggered)
    }
    
    private func addConstraints() {
        
        view.subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            loginImageView.topAnchor.constraint(equalTo: view.topAnchor),
            loginImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            loginBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75)
        ])
        
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: loginView.centerYAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 15),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            togglePasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            togglePasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            togglePasswordButton.widthAnchor.constraint(equalToConstant: 45),
            togglePasswordButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    /* An alternative approach is to create a separate function for adding each component to the view
     and another function for setting up constraints. This allows for local initialization of
     properties like stack view within each function, as they don't need to be accessed globally. */
    
    /// Configure the UI of the login screen
    //    private func configureUI() {
    //        configureLoginImageView()
    //        configureLoginView()
    //        configureLoginBackgroundImageView()
    //        configureLoginLabel()
    //        configureLoginWelcomeMessageLabel()
    //        configureLoginForm()
    //        configureTogglePassword()
    //    }
    //
    //    /// Add loginImageView and set its constraints
    //    private func configureLoginImageView() {
    //
    //        view.addSubview(loginImageView)
    //
    //        // MARK: Constraints
    //        NSLayoutConstraint.activate([
    //            loginImageView.topAnchor.constraint(equalTo: view.topAnchor),
    //            loginImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    //            loginImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    //            loginImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
    //        ])
    //    }
    //
    //    /// Add loginView and set its constraints
    //    private func configureLoginView() {
    //
    //        view.addSubview(loginView)
    //
    //        // MARK: Constraints
    //        NSLayoutConstraint.activate([
    //            loginView.topAnchor.constraint(equalTo: view.topAnchor),
    //            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    //            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    //            loginView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
    //        ])
    //    }
    //
    //    /// Add loginBackgroundImageView and set its constraints
    //    private func configureLoginBackgroundImageView() {
    //
    //        let loginBackgroundImageView = {
    //            let imageView = UIImageView()
    //            imageView.image = UIImage(resource: .loginBackground)
    //            imageView.translatesAutoresizingMaskIntoConstraints = false
    //            return imageView
    //        }()
    //
    //        view.addSubview(loginBackgroundImageView)
    //
    //        // MARK: Constraints
    //        NSLayoutConstraint.activate([
    //            loginBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    //            loginBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    //            loginBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    //            loginBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75)
    //        ])
    //    }
    //
    //    /// Add loginView and set its constraints
    //    private func configureLoginLabel() {
    //
    //        let logoLabel = LogoView(symbolImage: UIImage.SystemImages.graduationCap.image, logoText: "GradPro")
    //
    //        view.addSubview(logoLabel)
    //
    //        // MARK: Constraints
    //        NSLayoutConstraint.activate([
    //            logoLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
    //            logoLabel.centerYAnchor.constraint(equalTo: loginView.centerYAnchor, constant: 40)
    //        ])
    //    }
    //
    //    /// Add loginWelcomeMessageLabel and set its constraints
    //    private func configureLoginWelcomeMessageLabel() {
    //
    //        let welcomeLabel = {
    //            let label = UILabel()
    //            label.translatesAutoresizingMaskIntoConstraints = false
    //            label.text = "Login Today, Graduate Tomorrow!"
    //            label.textAlignment = .center
    //            label.textColor = .black
    //            label.numberOfLines = 0
    //            label.font = UIFont.boldSystemFont(ofSize: 20.0)
    //            return label
    //        }()
    //
    //        view.addSubview(welcomeLabel)
    //
    //        // MARK: Constraints
    //        NSLayoutConstraint.activate([
    //            welcomeLabel.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 15),
    //            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    //        ])
    //    }
    //
    //    /// Add login form and set its constraints
    //    private func configureLoginForm() {
    //
    //        let stackView = {
    //            let stackView = UIStackView(arrangedSubviews: [registrationIDTextField, passwordTextField, loginButton])
    //            stackView.axis = .vertical
    //            stackView.spacing = 70
    //            stackView.setCustomSpacing(120, after: passwordTextField)
    //            stackView.translatesAutoresizingMaskIntoConstraints = false
    //            stackView.alignment = .fill
    //            return stackView
    //        }()
    //
    //        view.addSubview(stackView)
    //
    //        // MARK: Constraints
    //        NSLayoutConstraint.activate([
    //            stackView.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 150),
    //            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
    //            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
    //        ])
    //    }
    //
    //    /// Configure togglePasswordButton and its constrainnts
    //    private func configureTogglePassword() {
    //
    //        view.addSubview(togglePasswordButton)
    //        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    //
    //        // MARK: Constraints
    //        NSLayoutConstraint.activate([
    //            togglePasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
    //            togglePasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
    //            togglePasswordButton.widthAnchor.constraint(equalToConstant: 45),
    //            togglePasswordButton.heightAnchor.constraint(equalToConstant: 45)
    //        ])
    //    }
    
    // This function is written without objective C in addViews function
    /// Handle the toggle password event
    //    @objc func togglePasswordVisibility() {
    //        passwordTextField.isSecureTextEntry.toggle()
    //        togglePasswordButton.isSelected = !passwordTextField.isSecureTextEntry
    //    }
}
