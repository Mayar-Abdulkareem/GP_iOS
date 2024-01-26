//
//  ItemDetailsImageTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 13/01/2024.
//

import UIKit
import Kingfisher

protocol ItemDetailsImageTableViewCellDelegate: AnyObject {
    func didPressEditButton()
}

struct ItemDetailsImageCellModel: StoreItemAddEditBaseCellModel {
    let imageString: String?
    let isEditable: Bool
}

class ItemDetailsImageTableViewCell: UITableViewCell {

    static let identifier = "ItemDetailsImageTableViewCell"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemImageView, editButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var editButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

        let button = UIButton(configuration: buttonConfig)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Upload", for: .normal)
        button.tintColor = .mySecondary
        button.backgroundColor = .myPrimary
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mySecondary.cgColor
        button.clipsToBounds = true
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.didPressEditButton()
        }, for: .primaryActionTriggered)
        return button
    }()
    
    lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    weak var delegate: ItemDetailsImageTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureViews() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            itemImageView.widthAnchor.constraint(equalToConstant: 180),
            itemImageView.heightAnchor.constraint(equalToConstant: 180),
            
            editButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configure(model: ItemDetailsImageCellModel) {
        if let imageString = model.imageString {
            itemImageView.showLoading(maskView: itemImageView)
            itemImageView.kf.setImage(with: URL(string: imageString)) {
                [weak self] _ in
                self?.itemImageView.hideLoading()
            }
        } else {
            itemImageView.image = UIImage.SystemImages.cart.image
            itemImageView.tintColor = .mySecondary
        }
        
        editButton.isHidden = !model.isEditable
    }
}
