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
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                iconImageView,
                verticalStackView
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                valueLabel
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.setContentHuggingPriority(.init(1000), for: .horizontal)
        label.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.setContentHuggingPriority(.init(251), for: .horizontal)
        label.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()

    init(
        icon: UIImage?,
        prefix: String,
        text: String,
        color: UIColor = .mySecondary,
        imageSize: CGFloat = 25,
        fontSize: CGFloat = 15,
        isSeparatorHidden: Bool = false
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
            fontSize: fontSize,
            isSeparatorHidden: isSeparatorHidden
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
        fontSize: CGFloat,
        isSeparatorHidden: Bool
    ) {
        addViewFillEntireView(
            horizontalStackView,
            top: 8,
            bottom: 8,
            leading: 16,
            trailing: 16
        )
        addSubview(separatorView)

        iconImageView.tintColor = color
        iconImageView.image = icon
        titleLabel.text = prefix
        valueLabel.text = text
        separatorView.isHidden = isSeparatorHidden

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: imageSize),
            iconImageView.heightAnchor.constraint(equalToConstant: imageSize),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func changeText(text: String) {
        self.currentValue = text
        titleLabel.text = currentPrefix
        valueLabel.text = text
    }
}
