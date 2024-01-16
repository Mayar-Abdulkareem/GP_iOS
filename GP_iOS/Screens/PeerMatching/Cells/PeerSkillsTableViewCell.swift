//
//  PeerSkillsTableViewCell.swift
//  GP_iOS
//
//  Created by FTS on 15/01/2024.
//

import UIKit

struct PeerSkillsTableViewCellModel {
    let title: String
    let description: String
    let iconType: PeerCellIconType
}

enum PeerCellIconType {
    case selected
    case notSelected
    case viewMore

    var image: UIImage? {
        switch self {
        case .selected:
            return .SystemImages.check.image
        case .viewMore:
            return .SystemImages.viewMore.image
        case .notSelected:
            return nil
        }
    }

    var tintColor: UIColor? {
        switch self {
        case .selected:
            return .mySecondary
        case .viewMore:
            return .myGray
        case .notSelected:
            return nil
        }
    }
}

class PeerSkillsTableViewCell: UITableViewCell {
    static let identifier = "PeerSkillsTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .myGray
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mySecondary
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
        configureViews()
    }

    private func configureViews() {
        backgroundColor = .myPrimary

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

//            iconImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configureCell(with model: PeerSkillsTableViewCellModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        iconImageView.image = model.iconType.image
        iconImageView.tintColor = model.iconType.tintColor
    }
}

