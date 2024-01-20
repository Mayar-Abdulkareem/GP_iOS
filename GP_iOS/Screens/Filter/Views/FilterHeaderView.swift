//
//  FilterHeader.swift
//  GP_iOS
//
//  Created by FTS on 17/12/2023.
//

import UIKit

class FilterHeaderView: UITableViewHeaderFooterView {

    static let identifier = "filterHeaderViewIdentifire"
    private var section: Int = 0

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func configureViews() {
        backgroundColor = .myLightGray
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(title: String) {
        label.text = title
    }
}
