//
//  LabelIconTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/01/2024.
//

import UIKit

struct LabelIconCellModel {
    let icon: UIImage
    let prefixText: String
    let valueText: String
    var isMoreIconHidden: Bool = true
    var isLastCell: Bool = false
}

class LabelIconTableViewCell: UITableViewCell {
    static let identifier = "LabelIconTableViewCell"


    private lazy var view = {
        let view = LabelIconView(
            icon: UIImage.SystemImages.status.image,
            prefix: "",
            text: "",
            isSeparatorHidden: true
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let icon = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.SystemImages.viewMore.image
        imageView.tintColor = UIColor.myGray
        return imageView
    }()

    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
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
        selectionStyle = .none

        contentView.addSubview(view)
        contentView.addSubview(icon)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -8),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),

            separatorView.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 8)
        ])
    }

    func configureCell(model: LabelIconCellModel) {
        icon.isHidden = model.isMoreIconHidden
        view.changePrefixText(text: model.prefixText)
        view.changeText(text: model.valueText)
        view.changeIcon(icon: model.icon)
        separatorView.isHidden = model.isLastCell
    }
}
