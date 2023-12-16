//
//  BasicCollectionViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 14/12/2023.
//

import UIKit

struct CourseCollectionViewCellModel {
    let title: String
    let icon: UIImage
}

class CourseCollectionViewCell: UICollectionViewCell {
    static let identifier = "shadowCollectionViewCellIdentifire"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.mySecondary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let viewWithShadow: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()
        addConstraints()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func addViews() {
        addViewFillEntireView(viewWithShadow, top: 8, bottom: 8, leading: 8, trailing: 8)
        viewWithShadow.addSubview(iconImageView)
        viewWithShadow.addSubview(titleLabel)
        /// Add properities
        viewWithShadow.addShadow()
        viewWithShadow.backgroundColor = UIColor.myPrimary
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: -10),
            iconImageView.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: 40),
        ])
    }
    
    func configureCell(model: CourseCollectionViewCellModel) {
        titleLabel.text = model.title
        iconImageView.image = model.icon
    }
}
