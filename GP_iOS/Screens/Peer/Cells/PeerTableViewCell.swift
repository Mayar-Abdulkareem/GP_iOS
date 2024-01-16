//
//  PeerTableViewCell.swift
//  GP_iOS
//
//  Created by FTS on 14/01/2024.
//

import UIKit

struct PeerTableViewCellModel {
    let title: String
    let background: UIColor
    let titleColor: UIColor
}

class PeerTableViewCell: UITableViewCell {
    static let identifier = "peerTableViewCellIdentifire"

    private let optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    private let viewWithShadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .myPrimary
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
        selectionStyle = .none
        configureViews()
    }

    private func configureViews() {
        backgroundColor = .myPrimary

        contentView.addViewFillEntireView(
            viewWithShadow,
            top: 16,
            bottom: 16,
            leading: 16,
            trailing: 16
        )

        viewWithShadow.addSubview(optionLabel)

        NSLayoutConstraint.activate([
            optionLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            optionLabel.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 20),
            optionLabel.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -20),
        ])
    }

    func configureCell(with model: PeerTableViewCellModel) {
        optionLabel.text = model.title
        optionLabel.textColor = model.titleColor
        viewWithShadow.backgroundColor = model.background
    }
}
