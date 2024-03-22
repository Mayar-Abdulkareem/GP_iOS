//
//  MoreTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/11/2023.
//

import UIKit

struct MoreCellModel {
    let title: String
    let icon: UIImage?
    var iconTintColor: UIColor = .darkGray
}

class MoreTableViewCell: UITableViewCell {

    static let identifier = "moreCellIdentifire"

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.darkGray
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        return label
    }()

    private let view = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    private func configureViews() {
        backgroundColor = .clear
        addViewFillEntireView(
            view,
            top: 10,
            bottom: 10,
            leading: 25,
            trailing: 25
        )
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),

            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    func configureCell(model: MoreCellModel) {
        iconImageView.image = model.icon
        iconImageView.tintColor = model.iconTintColor
        titleLabel.text = model.title
    }
}
