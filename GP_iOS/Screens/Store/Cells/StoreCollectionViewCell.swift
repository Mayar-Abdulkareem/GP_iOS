//
//  StoreCollectionViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 24/12/2023.
//

import UIKit

struct StoreCollectionViewCellModel {
    let image: UIImage
    let title: String
}

class StoreCollectionViewCell: UICollectionViewCell {
    static let identifier = "storeCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let itemImageView: UIImageView = {
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
        
        viewWithShadow.addSubview(itemImageView)
        viewWithShadow.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 8),
            itemImageView.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: -8),
            itemImageView.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 8),

            titleLabel.centerXAnchor.constraint(equalTo: itemImageView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 8)
        ])
    }
    
    func configureCell(model: StoreCollectionViewCellModel) {
        titleLabel.text = model.title
        itemImageView.image = model.image
    }
}
