//
//  HeaderTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 19/12/2023.
//

import UIKit

struct HeaderTableViewCellModel {
    let title: String
    let subtitle: String
    let image: UIImage
}

class HeaderTableViewCell: UITableViewCell {
    static let identifier = "HeaderTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .mySecondary
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage.project
        return image
    }()

    private let viewWithShadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadow()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    private func configureViews() {
        addViewFillEntireView(
            viewWithShadow,
            top: 20,
            bottom: 0,
            leading: 20,
            trailing: 20
        )

        viewWithShadow.addSubview(titleLabel)
        viewWithShadow.addSubview(subtitleLabel)
        viewWithShadow.addSubview(image)
        viewWithShadow.backgroundColor = .myPrimary

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(greaterThanOrEqualTo: viewWithShadow.topAnchor),
            image.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 10),
            image.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor),
            image.widthAnchor.constraint(equalToConstant: 170),
            image.heightAnchor.constraint(equalToConstant: 170),

            titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            titleLabel.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -10),

            subtitleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            subtitleLabel.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: -10),
            subtitleLabel.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -30)
        ])
    }

    func configureCell(model: HeaderTableViewCellModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        image.image = model.image
    }
}
