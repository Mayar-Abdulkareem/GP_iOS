//
//  LabeledIconView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/12/2023.
//

import UIKit

enum TagType: String {
    case submitted
    case notSubmitted

    var tagBackgrountColor: UIColor {
        switch self {
        case .submitted:
            return .mySecondary
        case .notSubmitted:
            return .red
        }
    }

    var tagStatus: String {
        switch self {
        case .submitted:
            return "Submitted"
        case .notSubmitted:
            return "Not Submitted"
        }
    }
}

class LabelIconView: UIView {

    private var currentPrefix: String = ""
    private var currentValue: String = ""

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        label.numberOfLines = 1
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
        fontSize: CGFloat = 20,
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

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(valueLabel)

        iconImageView.tintColor = color
        iconImageView.image = icon
        titleLabel.text = prefix
        valueLabel.text = text
        separatorView.isHidden = isSeparatorHidden

        NSLayoutConstraint.activate([

            iconImageView.widthAnchor.constraint(equalTo: titleLabel.heightAnchor),
            iconImageView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            //titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),

            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            //valueLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor)
        ])

    }

    func changeText(text: String) {
        self.currentValue = text
        titleLabel.text = currentPrefix
        valueLabel.text = text
    }

    func changePrefixText(text: String) {
        self.currentPrefix = text
        titleLabel.text = currentPrefix
        valueLabel.text = currentValue
    }

    func changeIcon(icon: UIImage) {
        iconImageView.image = icon
    }


    func setTag(tagType: TagType) {
        changeText(text: tagType.tagStatus)
        valueLabel.backgroundColor = tagType.tagBackgrountColor
        valueLabel.textColor = .white
        valueLabel.clipsToBounds = true
        valueLabel.textAlignment = .center

        layoutIfNeeded()

        valueLabel.layer.cornerRadius = valueLabel.bounds.height / 2

        updateLabelConstraints()
    }

    private func updateLabelConstraints() {
        valueLabel.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                valueLabel.removeConstraint(constraint)
            }
        }

        let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let widthConstraint = valueLabel.widthAnchor.constraint(equalToConstant: valueLabel.intrinsicContentSize.width + padding.left + padding.right)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
    }

}
