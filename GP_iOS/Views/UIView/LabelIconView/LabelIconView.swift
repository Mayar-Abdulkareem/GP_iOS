//
//  LabeledIconView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/12/2023.
//

import UIKit

class LabelIconView: UIView {

    private var currentPrefix: String = ""
    private var currentValue: String = ""

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    init(
        icon: UIImage?,
        prefix: String,
        text: String,
        color: UIColor = .mySecondary,
        imageSize: CGFloat = 25,
        fontSize: CGFloat = 15
    ) {
        super.init(frame: .zero)
        self.currentPrefix = prefix
        self.currentValue = text
        configureViews(
            icon: icon,
            prefix: prefix,
            text: text,
            color: color,
            imageSize: imageSize,
            fontSize: fontSize
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews(
        icon: UIImage?,
        prefix: String,
        text: String,
        color: UIColor,
        imageSize: CGFloat,
        fontSize: CGFloat
    ) {
        addSubview(iconImageView)
        addSubview(label)

        iconImageView.tintColor = color
        iconImageView.image = icon
        label.attributedText = StringManager.shared.createAttributedText(prefix: prefix, value: text)
        label.font = UIFont.systemFont(ofSize: fontSize)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: imageSize),
            iconImageView.heightAnchor.constraint(equalToConstant: imageSize),

            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
            //label.topAnchor.constraint(equalTo: topAnchor),
            //label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func changeText(text: String) {
        self.currentValue = text
        label.attributedText = StringManager.shared.createAttributedText(
            prefix: currentPrefix,
            value: currentValue
        )
    }
}
