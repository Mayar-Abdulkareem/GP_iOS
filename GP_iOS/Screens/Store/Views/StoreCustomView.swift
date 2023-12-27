//
//  StoreCustomView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 25/12/2023.
//

import UIKit

class StoreCustomView: UIView {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mySecondary
        return imageView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.isEnabled = false
        textField.textColor = .gray
        textField.tintColor = .mySecondary
        return textField
    }()
    
    private lazy var quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.value = Double(AppManager.shared.item?.quantity ?? "1.0") ?? 1.0
        stepper.minimumValue = 1
        stepper.tintColor = UIColor.mySecondary
        stepper.isHidden = true
        
        stepper.addAction(UIAction { [weak self] _ in
            self?.textField.text = String(Int(stepper.value))
        }, for: .primaryActionTriggered)
        return stepper
    }()
    
    private lazy var copyButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.SystemImages.copy.image
        //configuration.imagePlacement = .all
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.gray
        button.isHidden = true
        button.contentMode = .scaleAspectFit
        
        button.addAction(UIAction { [weak self] _ in
            UIPasteboard.general.string = self?.textField.text
        }, for: .primaryActionTriggered)
                               
        return button
    }()
    
    init(icon: UIImage?, textFieldText: String?, textFieldPlaceHolder: String? = nil, isCopyIconEnable: Bool = false, isEditable: Bool = false) {
        super.init(frame: .zero)
        iconImageView.image = icon
        
        textField.text = textFieldText
        textField.isEnabled = isEditable
        textField.placeholder = textFieldPlaceHolder
        textField.borderStyle = (isEditable) ? .roundedRect : .none
        
        copyButton.isHidden = !isCopyIconEnable
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        
        addSubview(iconImageView)
        addSubview(textField)
        addSubview(quantityStepper)
        addSubview(copyButton)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            quantityStepper.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            quantityStepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            quantityStepper.topAnchor.constraint(equalTo: topAnchor),
            quantityStepper.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            copyButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 4),
            copyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            copyButton.widthAnchor.constraint(equalToConstant: 10),
            copyButton.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    func isEnableTextFileld(_ isEnable: Bool) {
        textField.isEnabled = isEnable
        textField.borderStyle = isEnable ? .roundedRect : .none
    }
    
    func showStepperValue(quantity: String, isHidden: Bool) {
        quantityStepper.isHidden = isHidden
        quantityStepper.value = Double(Int(quantity) ?? 1)
    }
    
    func getTextFieldWidthAchor() -> NSLayoutDimension{
        return textField.widthAnchor
    }
}
