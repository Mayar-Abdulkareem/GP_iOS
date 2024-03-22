//
//  ItemAddEditCheckBoxTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 25/01/2024.
//

import UIKit

protocol ItemAddEditCheckBoxTableViewCellDelegate: AnyObject {
    func didUpdateCheckBox(isSelected: Bool)
}

struct ItemAddEditCheckBoxCellModel: StoreItemAddEditBaseCellModel {
    let isSelected: Bool
}

class ItemAddEditCheckBoxTableViewCell: UITableViewCell {
    
    static let identifier = "ItemAddEditCheckBoxTableViewCell"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            checkboxButton, titleLabel
        ])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.black
        label.text = String.LocalizedKeys.shareMyPhoneNumber.localized
        return label
    }()
    
    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .mySecondary
        button.contentMode = .scaleAspectFill
        button.setImage(UIImage.SystemImages.circle.image, for: .normal)
        button.setImage(UIImage.SystemImages.circleFill.image, for: .selected)
        button.addAction(UIAction { [weak self] _ in
            button.isSelected.toggle()
            self?.delegate?.didUpdateCheckBox(isSelected: button.isSelected)
        }, for: .primaryActionTriggered)

        return button
    }()
    
    weak var delegate: ItemAddEditCheckBoxTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addViewFillEntireView(
            stackView,
            top: 10,
            bottom: 10,
            leading: 25,
            trailing: 20
        )
        
        NSLayoutConstraint.activate([
            checkboxButton.widthAnchor.constraint(equalToConstant: 30),
            checkboxButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configure(model: ItemAddEditCheckBoxCellModel) {
        checkboxButton.isSelected = model.isSelected
    }
}
