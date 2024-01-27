//
//  SubmissionDatesTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/01/2024.
//

import UIKit

class SubmissionDatesTableViewCell: UITableViewCell {
    static let identifier = "SubmissionDatesTableViewCell"

    private lazy var openedDate = {
        let date = LabelIconView(
            icon: UIImage.SystemImages.year.image,
            prefix: "Opened",
            text: "test",
            isSeparatorHidden: true
        )
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()

    private lazy var dueDate = {
        let date = LabelIconView(
            icon: nil,
            prefix: "Due",
            text: "test"
        )
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
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

        contentView.addSubview(openedDate)
        contentView.addSubview(dueDate)

        NSLayoutConstraint.activate([
            openedDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            openedDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            openedDate.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
       //     openedDate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)

            dueDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dueDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dueDate.topAnchor.constraint(equalTo: openedDate.bottomAnchor, constant: 8),
//            dueDate.heightAnchor.constraint(equalToConstant: 200),
            dueDate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

        ])
    }

    func configureCell(opened: String, due: String) {
        openedDate.changeText(text: opened)
        dueDate.changeText(text: due)
    }
}

