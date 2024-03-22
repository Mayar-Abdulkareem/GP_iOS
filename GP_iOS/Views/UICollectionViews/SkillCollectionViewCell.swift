//
//  SkillCollectionViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 02/01/2024.
//

import UIKit

class SkillCollectionViewCell: UICollectionViewCell {
    static let identifier = "SkillCollectionViewCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private let viewWithShadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.myPrimary
        view.addShadow()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addViewFillEntireView(
            viewWithShadow,
            top: 8,
            bottom: 8,
            leading: 8,
            trailing: 8
        )
        viewWithShadow.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor)
        ])
    }

    func configureCell(with skillName: String) {
        nameLabel.text = skillName
    }
}
