//
//  ItemEditTextFieldView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 21/01/2024.
//

import UIKit

class ItemEditTextFieldView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.backgroundColor = UIColor.textFieldBackground
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.tintColor = UIColor.mySecondary
        textField.returnKeyType = .done

        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear

        addSubview(titleLabel)
        addSubview(textField)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 45),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setTextFieldContentInset()
    }

    private func setTextFieldContentInset() {
        let frame = CGRect(x: 0, y: 0, width: 15, height: 0)
        textField.leftView = UIView(frame: frame)
        textField.rightView = UIView(frame: frame)
        textField.leftViewMode = .always
        textField.rightViewMode = .always
    }

    func configureView(
        title: String,
        value: String?,
        keyboardType: UIKeyboardType
    ) {
        textField.text = value
        textField.keyboardType = keyboardType
        textField.addKeyboardToolbarDoneButton(rightButtonSelector: #selector(doneButtonPressed), target: self)
        
        titleLabel.text = title
    }
    
    @objc private func doneButtonPressed() {
        textField.resignFirstResponder()
    }
}
