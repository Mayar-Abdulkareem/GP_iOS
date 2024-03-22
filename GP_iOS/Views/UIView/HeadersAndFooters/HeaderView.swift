//
//  HeaderView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit

protocol HeaderViewControllerDelegate: AnyObject {
    func chatButtonTapped()
}

class HeaderView: UIView {

    weak var delegate: HeaderViewControllerDelegate?

//    private let notificationButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        let image = UIImage.SystemImages.notification.image.withConfiguration(
//            UIImage.SymbolConfiguration(pointSize: 27.5)
//        )
//        button.setImage(image, for: .normal)
//        button.tintColor = UIColor.darkMain
//        return button
//    }()

    private lazy var chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage.SystemImages.chat.image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 27.5))
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.darkMain

        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.chatButtonTapped()
        }, for: .primaryActionTriggered)
        return button
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.gradProHorizontal
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureViews()
    }

    private func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .mainBackground
        configureShadow()
        layer.cornerRadius = 20

        let stackView = UIStackView(
            arrangedSubviews: [
                chatButton,
//                notificationButton
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10

        addSubview(stackView)
        addSubview(logoImageView)

        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            chatButton.widthAnchor.constraint(equalToConstant: 30),
            chatButton.heightAnchor.constraint(equalToConstant: 30),

            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            logoImageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    private func configureShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
    }
}
