//
//  FooterButtonView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/01/2024.
//

import UIKit

import UIKit

enum CustomButtonType {
    case disabled
    case primary
    case secondary
    case delete
    case add

    var backgroundColor: UIColor {
        switch self {
        case .disabled:
            return .myLightGray
        case .delete:
            return .systemRed
        default:
            return .mySecondary.withAlphaComponent(0.8)
        }
    }

    var textColor: UIColor {
        switch self {
        case .disabled:
            return .gray
        default:
            return .myPrimary
        }
    }

    var isEnabled: Bool {
        switch self {
        case .disabled:
            return false
        default:
            return true
        }
    }
}

@objc protocol FooterButtonViewDelegate: AnyObject {
    func primaryButtonTapped()
    @objc optional func secondaryButtonTapped()
}

class FooterButtonView: UIView {

    weak var delegate: FooterButtonViewDelegate?

    private lazy var primaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8

        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.primaryButtonTapped()
        }, for: .primaryActionTriggered)
        return button
    }()

    private lazy var secondaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8

        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.secondaryButtonTapped?()
        }, for: .primaryActionTriggered)
        return button
    }()

    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale).isActive = true
        return view
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [secondaryButton, primaryButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    init(
        primaryButtonType: CustomButtonType = .primary,
        primaryButtonTitle: String? = nil,
        secondaryButtonType: CustomButtonType = .secondary,
        secondaryButtonTitle: String? = nil
    ) {
        super.init(frame: .zero)
        setupViews()

        configure(
            primaryButtonType: primaryButtonType,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonType: secondaryButtonType,
            secondaryButtonTitle: secondaryButtonTitle
        )
    }

    func configure(
        primaryButtonType: CustomButtonType = .primary,
        primaryButtonTitle: String? = nil,
        secondaryButtonType: CustomButtonType = .secondary,
        secondaryButtonTitle: String? = nil
    ) {
        configureButton(
            button: secondaryButton,
            buttonType: secondaryButtonType,
            buttonTitle: secondaryButtonTitle
        )

        configureButton(
            button: primaryButton,
            buttonType: primaryButtonType,
            buttonTitle: primaryButtonTitle
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(separatorLine)
        addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),

            buttonsStackView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 16),
            buttonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func configureButton(
        button: UIButton,
        buttonType: CustomButtonType,
        buttonTitle: String?
    ) {
        button.setTitle(buttonTitle, for: .normal)
        button.isEnabled = buttonType.isEnabled
        button.backgroundColor = buttonType.backgroundColor
        button.setTitleColor(buttonType.textColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.isHidden = (buttonTitle == nil)
    }

    func changePrimaryButtonType(type: CustomButtonType) {
        primaryButton.backgroundColor = type.backgroundColor
        primaryButton.setTitleColor(type.textColor, for: .normal)
        primaryButton.isEnabled = type.isEnabled
    }

    func changePrimaryButtonText(text: String) {
        primaryButton.setTitle(text, for: .normal) 
    }

    func changeSecondaryButtonType(type: CustomButtonType) {
        secondaryButton.backgroundColor = type.backgroundColor
        secondaryButton.setTitleColor(type.textColor, for: .normal)
        secondaryButton.isEnabled = type.isEnabled
    }

    func changeSecondaryButtonText(text: String) {
        secondaryButton.setTitle(text, for: .normal)
    }

    func addAlphaToPrimary() {
        primaryButton.alpha = 0.8
    }

    func showSecondary(isHidden: Bool) {
        secondaryButton.isHidden = isHidden
        changeSecondaryButtonType(type: .secondary)
    }
}
