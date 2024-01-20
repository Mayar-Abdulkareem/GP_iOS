//
//  PeerMatchingHeaderView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 16/01/2024.
//

import UIKit

class PeerMatchingHeaderView: UIView {

    private let button: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 0
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = configuration
        button.setImage(.SystemImages.register.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .mySecondary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        addSubview(button)
        addSubview(label)

        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30),

            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
            label.heightAnchor.constraint(equalToConstant: 25),
        ])
    }

    func configure(title: String, isEditButtonHidden: Bool) {
        label.text = title
        button.isHidden = isEditButtonHidden
    }
}
