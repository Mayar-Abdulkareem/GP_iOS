//
//  ItemDetailsImageTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 13/01/2024.
//

import UIKit
import Kingfisher

class ItemDetailsImageTableViewCell: UITableViewCell {

    static let identifier = "ItemDetailsImageTableViewCell"
    
    lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        contentView.addViewFillEntireView(itemImageView, top: 8, bottom: 8, leading: 80, trailing: 80)
        
        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor)
        ])
    }
    
    func configure(imageString: String) {
        itemImageView.showLoading(maskView: itemImageView)
        itemImageView.kf.setImage(with: URL(string: imageString)) {
            [weak self] _ in
            self?.itemImageView.hideLoading()
        }
    }
}
