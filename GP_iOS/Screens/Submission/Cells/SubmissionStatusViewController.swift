//
//  SubmissionStatusViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/01/2024.
//

import UIKit

class SubmissionStatusViewController: UITableViewCell {
    static let identifier = "SubmissionStatusViewController"


    private lazy var status = {
        let date = LabelIconView(
            icon: UIImage.SystemImages.status.image,
            prefix: "Status",
            text: "test",
            isSeparatorHidden: true
        )
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
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

        contentView.addSubview(status)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            status.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            status.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            status.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            separatorView.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: status.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 8)
        ])
    }

    func configureCell(tagType: TagType, isLastCell: Bool) {
        status.setTag(tagType: tagType)
        separatorView.isHidden = isLastCell
    }
}
