//
//  AssignmentTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 21/01/2024.
//

import UIKit

struct AssignmentCellModel {
    let title: String
    let date: String
}

class AssignmentTableViewCell: UITableViewCell {
    static let identifier = "AssignmentTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .myAccent
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .myGray
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
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    private func configureViews() {
        selectionStyle = .none

        addViewFillEntireView(
            viewWithShadow,
            top: 10,
            bottom: 10,
            leading: 20,
            trailing: 20
        )

        viewWithShadow.addSubview(titleLabel)
        viewWithShadow.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 20),

            dateLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -20)
        ])
    }

    func configureCell(model: AssignmentCellModel) {
        titleLabel.text = model.title
        dateLabel.text = String.LocalizedKeys.due.localized + ": " + model.date
    }
}

