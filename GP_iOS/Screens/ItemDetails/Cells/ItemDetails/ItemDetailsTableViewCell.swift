//
//  ItemDetailsTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 13/01/2024.
//

import UIKit

struct ItemDetailsTableViewCellModel {
    let image: UIImage?
    let title: String
    var showCopyButton: Bool = false
}

class ItemDetailsTableViewCell: UITableViewCell {
    static let identifier = "ItemDetailsTableViewCell"
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mySecondary
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var copyButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.SystemImages.copy.image
        // configuration.imagePlacement = .all

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.gray
        button.isHidden = true
        button.contentMode = .scaleAspectFit

        button.addAction(UIAction {
            [weak self] _ in
            UIPasteboard.general.string = self?.titleLabel.text
        }, for: .primaryActionTriggered)

        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                iconImageView,
                titleLabel,
                copyButton
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.setCustomSpacing(16, after: iconImageView)
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    private func configureViews() {
        contentView.addViewFillEntireView(stackView, top: 16, bottom: 16, leading: 16, trailing: 16)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            copyButton.widthAnchor.constraint(equalToConstant: 25),
            copyButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    func configure(model: ItemDetailsTableViewCellModel) {
        iconImageView.image = model.image
        titleLabel.text = model.title
        copyButton.isHidden = !model.showCopyButton
    }
}
