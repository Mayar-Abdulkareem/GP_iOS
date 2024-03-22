//
//  ItemEditStepperView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 25/01/2024.
//

import UIKit

protocol ItemEditStepperViewDelegate: AnyObject {
    func didUpdateQuantity(newValue: Double)
}

class ItemEditStepperView: UIView {
    
    private lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .mySecondary
        let decrementButtonImage = UIImage.SystemImages.minus.image.withConfiguration(
            UIImage.SymbolConfiguration(
                weight: .medium
            )
        )
        button.setImage(decrementButtonImage, for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.decrementButtonPressed()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .mySecondary
        let incrementButtonImage = UIImage.SystemImages.plus.image.withConfiguration(
            UIImage.SymbolConfiguration(
                weight: .medium
            )
        )
        button.setImage(incrementButtonImage, for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.incrementButtonPressed()
        }, for: .touchUpInside)
        return button
    }()
    
    lazy var valueTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.keyboardType = .decimalPad
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.addKeyboardToolbarDoneButton(rightButtonSelector: #selector(doneButtonPressed), target: self)
        return textField
    }()
    
    var value: Double = 0 {
        didSet {
            value = value.rounded(.towardZero)
            valueTextField.text = "\(value)"
            delegate?.didUpdateQuantity(newValue: value)
        }
    }
    
    weak var delegate: ItemEditStepperViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.myGray.cgColor
        layer.cornerRadius = 10
        clipsToBounds = true
        setupView()
    }

    private func setupView() {
        [valueTextField, decrementButton, incrementButton].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            decrementButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            decrementButton.trailingAnchor.constraint(equalTo: valueTextField.leadingAnchor, constant: -4),
            decrementButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            decrementButton.widthAnchor.constraint(equalToConstant: 30),
            decrementButton.heightAnchor.constraint(equalToConstant: 30),
            
            valueTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            valueTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            incrementButton.leadingAnchor.constraint(equalTo: valueTextField.trailingAnchor, constant: 4),
            incrementButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            incrementButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            incrementButton.widthAnchor.constraint(equalToConstant: 30),
            incrementButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func decrementButtonPressed() {
        guard value >= 2.0 else { return }
        value -= 1.0
    }
    
    private func incrementButtonPressed() {
        value += 1.0
    }
    
    @objc private func doneButtonPressed(sender: Any) {
        valueTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension ItemEditStepperView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        return formatter.number(from: updatedText) != nil || updatedText.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            value = Double(text) ?? 0
        }
        textField.sizeToFit()
    }
}
