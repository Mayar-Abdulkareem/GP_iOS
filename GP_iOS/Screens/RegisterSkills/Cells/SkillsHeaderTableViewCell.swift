//
//  SkillsHeaderTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/01/2024.
//

import UIKit

class SkillsTableViewHeader: UIView {

    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.text = String.LocalizedKeys.matchingPeerInfoLabelText.localized
        label.textColor = UIColor.gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    private func configureViews() {
        addViewFillEntireView(
            informationLabel,
            top: 8,
            bottom: 8,
            leading: 8,
            trailing: 8
        )
    }
}
