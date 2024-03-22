//
//  AdminTableViewCell.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import UIKit

struct AdminTableCellModel {
    let data: [AdminTableCellDataModel]
}

struct AdminTableCellDataModel {
    let value: String?
    var textColor: UIColor? = nil
}

class AdminTableViewCell: UITableViewCell {

    static let identifier = "AdminTableViewCell"

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        view.heightAnchor.constraint(
            equalToConstant: 1 / UIScreen.main.scale
        ).isActive = true
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

    private func configureViews() {
        contentView.addViewFillEntireView(
            stackView,
            top: 10,
            bottom: 10,
            leading: 20,
            trailing: 20
        )
        contentView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func configure(
        model: AdminTableCellModel,
        isLastCell: Bool
    ) {
        selectionStyle = .none
        separatorView.isHidden = isLastCell
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        model.data.enumerated().forEach { (index, data) in
            let isFirstCell = index == 0
            let label = UILabel()
            label.text = data.value

            let fontSize: CGFloat = isFirstCell ? 17 : 16
            let fontWeight: UIFont.Weight = isFirstCell ? .semibold : .regular
            label.font = UIFont.systemFont(
                ofSize: fontSize,
                weight: fontWeight
            )

            if let textColor = data.textColor {
                label.textColor = textColor
            } else {
                label.textColor = isFirstCell ? .darkMain : .subTitle
            }

            stackView.addArrangedSubview(label)
        }
    }
}
