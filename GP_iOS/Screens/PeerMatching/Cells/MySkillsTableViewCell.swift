//
//  MySkillsTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/01/2024.
//

import UIKit

class MySkillsTableViewCell: UITableViewCell {

    static let identifier = "MySkillsTableViewCell"

    private let skillsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
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

        contentView.addSubview(skillsLabel)
        skillsLabel.attributedText = MatchingPeerManager.shared.getMySkillsAttributedString()

        NSLayoutConstraint.activate([
            skillsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            skillsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            skillsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            skillsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func configureCell(mySkills: NSAttributedString) {
        skillsLabel.attributedText = mySkills
    }
}
