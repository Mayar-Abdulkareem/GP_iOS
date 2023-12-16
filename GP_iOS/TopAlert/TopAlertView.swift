//
//  TopAlertView.swift
//  Paycard
//
//  Created by Mayar Abdulkareem on 08/11/2023.
//  Copyright © 2023 R365. All rights reserved.
//

import UIKit

// MARK: - Top Alert Type

/// Represents the type of alert to be displayed.
enum TopAlertType {
    case success
    case failure
    case info
    
    /// Retrieves the icon image associated with the alert type.
    var icon: UIImage? {
        switch self {
        case .success:
            return UIImage.SystemImages.check.image
        case .failure:
            return UIImage.SystemImages.xmark.image
        case .info:
            return UIImage.SystemImages.info.image
        }
    }
    
    /// Retrieves the icon color associated with the alert type.
    var iconColor: UIColor {
        switch self {
        case .success:
            return UIColor.green
        case .failure:
            return UIColor(resource: .failure)
        case .info:
            return UIColor.orange.withAlphaComponent(0.9)
        }
    }
}

// MARK: - Top Alert View

/// A custom view for displaying an alert with an icon, title, and subtitle.
class TopAlertView: UIView {
    
    // MARK: - Private Properties
    
    /// The view that provides a blurred background effect.
    private var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    /// The image view that displays the alert icon.
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// The label that displays the main title of the alert.
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()
    
    /// The label that displays the subtitle of the alert.
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .subTitle)
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    // MARK: - Configuration
    
    /// Configures the view with specified title, subtitle, and alert type.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - subTitle: The subtitle of the alert.
    ///   - type: The type of the alert (success, failure, info).
    func configureView(title: String,
                       subTitle: String,
                       type: TopAlertType) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        iconImageView.image = type.icon
        iconImageView.tintColor = type.iconColor
    }
    
    // MARK: - Private Setup
    
    /// Sets up the view by adding and configuring subviews and appearance.
    private func initialize() {
        configureGestureRecognizer()
        configureShadowView()
        configureSubViews()
    }
    
    /// Configures and adds subviews to the main view.
    private func configureSubViews() {
        addViewFillEntireView(visualEffectView)
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        setupConstraints()
    }
    
    /// Sets up constraints for subviews.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Constraints for iconImageView
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            
            // Constraints for titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Constraints for subTitleLabel
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    /// Configures the shadow effect for the view.
    private func configureShadowView() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.65).cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
    
    /// Configures a gesture recognizer for the view.
    private func configureGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickAction(_:)))
        addGestureRecognizer(gesture)
    }
    
    // MARK: - Interaction Handlers
    
    /// Handles the tap gesture, triggering the removal of the view.
    /// - Parameter sender: The gesture recognizer that triggered the action.
    @objc private func clickAction(_ sender: UITapGestureRecognizer) {
        removeView()
    }
    
    /// Animates and removes the view from its superview.
    private func removeView() {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseIn,
                       animations: {
            self.frame.origin.y = -self.bounds.height
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Public Interface
    
    /// Displays the alert view with animation.
    /// - Parameters:
    ///   - duration: Optional duration after which the alert will be removed.
    ///   - completion: Optional completion handler after the alert is removed.
    func displayView(duration: TimeInterval?,
                     completion: (() -> Void)? = nil) {
        frame.origin.y = -100
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.frame.origin.y = 0
        }, completion: { _ in
            if let duration = duration {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    completion?()
                    self.removeView()
                }
            }
        })
    }
}
