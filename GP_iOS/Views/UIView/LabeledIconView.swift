//
//  LabeledIconView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/12/2023.
//

import UIKit

class LabeledIconView: UIView {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    init(icon: UIImage?, prefix: String, text: String, color: UIColor = .mySecondary) {
        super.init(frame: .zero)
        configureViews(icon: icon, prefix: prefix, text: text, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(icon: UIImage?, prefix: String, text: String, color: UIColor) {
        addSubview(iconImageView)
        addSubview(label)
        
        iconImageView.tintColor = color
        iconImageView.image = icon
        label.attributedText = StringManager.shared.createAttributedText(prefix: prefix, value: text)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

