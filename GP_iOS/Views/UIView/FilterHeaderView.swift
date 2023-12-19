//
//  FilterHeader.swift
//  GP_iOS
//
//  Created by FTS on 17/12/2023.
//

import UIKit

class FilterHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "filterHeaderViewIdentifire"
    var filterButtonTappedHandler: ((_ isTypeFilter: Bool) -> Void)?
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
        addViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        addSubview(label)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func configure(title: String) {
        label.text = title
    }
}
