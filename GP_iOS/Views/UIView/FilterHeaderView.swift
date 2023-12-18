//
//  FilterHeader.swift
//  GP_iOS
//
//  Created by FTS on 17/12/2023.
//

import UIKit

//protocol FilterHeaderViewDelegate: AnyObject {
//    func clearFilterHandle(isTypeFilter: Bool)
//}

class FilterHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "filterHeaderViewIdentifire"
//    weak var delegate: FilterHeaderViewDelegate?
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
    
//    private let clearFilterButton = {
//        var configuration = UIButton.Configuration.plain()
//        configuration.image = UIImage.SystemImages.clearFilter.image
//        configuration.imagePlacement = .all
//        
//        let button = UIButton(configuration: configuration, primaryAction: nil)
//        button.addTarget(FilterHeaderView.self, action: #selector(filterButtonTapped), for: .touchUpInside)
//        button.tintColor = UIColor.gray
//        return button
//    }()
    
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
        //backgroundColor = UIColor.myLightGray
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
    
//    @objc func filterButtonTapped() {
//        if section == 0{
//            /// Date selected
//            //delegate?.clearFilterHandle(isTypeFilter: false)
//            filterButtonTappedHandler?(false)
//        } else {
//            /// Type selected
//            //delegate?.clearFilterHandle(isTypeFilter: true)
//            filterButtonTappedHandler?(true)
//        }
//    }
}
