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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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


        skillsLabel.attributedText = MatchingPeerManager.shared.getMySkillsAttributedString()

        contentView.addViewFillEntireView(
            skillsLabel,
            top: 5,
            leading: 16,
            trailing: 16
        )
    }

    func configureCell(mySkills: NSAttributedString) {
        skillsLabel.attributedText = mySkills
    }
}
