//
//  ItemAddEditTextTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 17/01/2024.
//

import UIKit

protocol ItemAddEditTextTableViewCellDelegate: AnyObject {
    func didChangeText(fieldTypes: ItemAddEditTextCellType, value: String)
}

enum ItemAddEditTextCellType: Int, CaseIterable {
    case name, price, location

    var keyboardType: UIKeyboardType {
        switch self {
        case .price:
            UIKeyboardType.numberPad
        default:
            UIKeyboardType.default
        }
    }

    var displayString: String {
        switch self {
        case .name: String.LocalizedKeys.enterItemName.localized
        case .price: String.LocalizedKeys.enterItemPrice.localized
        case .location: String.LocalizedKeys.enterItemLocation.localized
        }
    }
}

struct ItemAddEditTextCellModel: StoreItemAddEditBaseCellModel {
    let fieldTypes: ItemAddEditTextCellType
    let value: String
}

class ItemAddEditTextTableViewCell: UITableViewCell {
    
    static let identifier = "ItemAddEditTextTableViewCell"
    
    let inputTextField = ItemEditTextFieldView()
    private var textFieldModel: ItemAddEditTextCellModel?
    weak var delegate: ItemAddEditTextTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addViewFillEntireView(
            inputTextField,
            top: 10,
            bottom: 10,
            leading: 20,
            trailing: 20
        )
    }
    
    func configure(model: ItemAddEditTextCellModel) {
        self.textFieldModel = model
        
        inputTextField.configureView(
            title: model.fieldTypes.displayString,
            value: model.value,
            keyboardType: model.fieldTypes.keyboardType
        )
        inputTextField.textField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension ItemAddEditTextTableViewCell: UITextFieldDelegate {

    func textFieldDidEndEditing( _ textField: UITextField) {
        guard let textFieldModel else { return }
        
        let newValue = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        delegate?.didChangeText(
            fieldTypes: textFieldModel.fieldTypes,
            value: newValue
        )

        textField.text = newValue
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
