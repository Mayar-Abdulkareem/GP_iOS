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
    static let identifier = "courseCollectionViewCellIdentifire"
    
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.myPrimary
        view.addShadow()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
            leading: 8,
            trailing: 8
        )
        
        viewWithShadow.addSubview(iconImageView)
        viewWithShadow.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: -10),
            iconImageView.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: 40),
        ])
    }
    
    func configureCell(model: CourseCollectionViewCellModel?) {
        titleLabel.text = model?.title
        iconImageView.image = model?.icon
    }
}
