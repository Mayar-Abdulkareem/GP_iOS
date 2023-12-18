//
//  HeaderView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit

class MainView: UIView {
            
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let logoView: UIView = {
        let view = LogoView(
            heightAndWidth: 30,
            logoTextSize: 20,
            weight: .regular
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.SystemImages.notification.image
        imageView.tintColor = UIColor.myPrimary
        return imageView
    }()
    
    private let chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.SystemImages.chat.image
        imageView.tintColor = UIColor.myPrimary
        return imageView
    }()
    
    private let gradientLayer = CAGradientLayer()

    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        
        addViews()
        addConstraints()
        setupGradient()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the gradient layer covers the full bounds of the view
        gradientLayer.frame = self.bounds
    }
    
    private func addViews() {
        addSubview(logoView)
        addSubview(titleLabel)
        addSubview(notificationImageView)
        addSubview(chatImageView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            logoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            
            notificationImageView.heightAnchor.constraint(equalToConstant: 25),
            notificationImageView.widthAnchor.constraint(equalToConstant: 25),
            notificationImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            notificationImageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            
            chatImageView.heightAnchor.constraint(equalToConstant: 25),
            chatImageView.widthAnchor.constraint(equalToConstant: 25),
            chatImageView.trailingAnchor.constraint(equalTo: notificationImageView.leadingAnchor, constant: -10),
            chatImageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    private func setupGradient() {
        // Configure the gradient here
        gradientLayer.colors = [
            UIColor.mySecondary.cgColor,
            UIColor.myGray.cgColor
        ] // Your gradient colors
        gradientLayer.locations = [0.0, 1.0] // Start and end points of the gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // Horizontal gradient
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // Insert the gradient layer to the view's layer
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
