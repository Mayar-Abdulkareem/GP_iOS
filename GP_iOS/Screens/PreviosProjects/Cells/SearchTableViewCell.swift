//
//  SearchTableViewCell.swift
//  GP_iOS
//
//  Created by FTS on 16/12/2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let identifier = "searchTableViewCellIdentifire"

    private let projectNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.SystemImages.viewMore.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.gray
        return imageView
    }()

    private let viewWithShadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.myPrimary
        view.addShadow(
            cornerRadius: 5,
            shadowOpacity: 0.1,
            shadowRadius: 4
        )
        return view
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
        addViewFillEntireView(
            viewWithShadow,
            top: 8,
            bottom: 8,
            leading: 16,
            trailing: 16
        )

        let stackView = UIStackView(
            arrangedSubviews: [
                projectNameLabel,
                getHorizontalStack(icon: UIImage.SystemImages.projectType.image, label: detailsLabel),
                getHorizontalStack(icon: UIImage.SystemImages.year.image, label: yearLabel)
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(5, after: projectNameLabel)
        stackView.axis = .vertical
        stackView.spacing = 3

        viewWithShadow.addSubview(stackView)
        viewWithShadow.addSubview(arrowImageView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -16),

            arrowImageView.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: -16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 10),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configureCell(model: PreviousProject) {
        projectNameLabel.text = model.name
        yearLabel.text = model.date
        detailsLabel.text = model.projectType
    }

    private func getHorizontalStack(
        icon: UIImage,
        label: UILabel
    ) -> UIStackView {
        //        let imageView = UIImageView(image: icon)
        //        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.contentMode = .scaleAspectFit
        //        imageView.tintColor = UIColor.mySecondary.al
        //        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5

        return stackView
    }
}
