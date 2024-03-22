//
//  ItemAddEditQuantityTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 23/01/2024.
//

import UIKit

struct ItemAddEditQuantityCellModel: StoreItemAddEditBaseCellModel {
    let quantity: Double
}

class ItemAddEditQuantityTableViewCell: UITableViewCell {

    static let identifier = "ItemAddEditQuantityTableViewCell"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, quantityStepper
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
        label.textAlignment = .left
        label.text = "Quantity"
        return label
    }()
    
    lazy var quantityStepper: ItemEditStepperView = {
        let stepper = ItemEditStepperView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.value = 1.0
        return stepper
    }()

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
            leading: 35,
            trailing: 20
        )
        quantityStepper.widthAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    func configure(model: ItemAddEditQuantityCellModel) {
        //quantityStepper.valueTextField.text = "\(model.quantity)"
        quantityStepper.value = model.quantity
    }
}
