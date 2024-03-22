//
//  RegisterTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 03/01/2024.
//

import UIKit

struct RegisterCellModel {
    let title: String
    let iconImage: UIImage?
    let isIconHidden: Bool
    let isLastCell: Bool
}

class RegisterTableViewCell: UITableViewCell {

    static let identifier = "registerTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mySecondary
        return imageView
    }()

    private let selectedIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mySecondary
        return imageView
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .myGray
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isSelected {
            selectedIconImageView.isHidden = false
            selectedIconImageView.image = UIImage.checkmark
        } else {
            selectedIconImageView.isHidden = true
        }
    }

    func configureViews() {
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(selectedIconImageView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),

            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),

            selectedIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            selectedIconImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            selectedIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            selectedIconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            selectedIconImageView.widthAnchor.constraint(equalToConstant: 25),
            selectedIconImageView.heightAnchor.constraint(equalToConstant: 25),

            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
        ])
    }

    func configureCell(with model: RegisterCellModel) {
        titleLabel.text = model.title
        iconImageView.image = model.iconImage
        iconImageView.isHidden = model.isIconHidden
        separatorView.isHidden = model.isLastCell
    }
}
