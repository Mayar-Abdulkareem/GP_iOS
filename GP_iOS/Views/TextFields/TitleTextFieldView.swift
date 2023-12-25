//
//  TitleTextFieldView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 25/12/2023.
//

import UIKit

class TitleTextFieldView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    lazy var textField: ImageTextField = {
        let textField = ImageTextField(
            iconsTintColor: iconsTintColor,
            leftImage: leftImage,
            cornerRadius: cornerRadius,
            isSecureTextEntry: isSecureTextEntry
        )
        
        textField.tintColor = UIColor.mySecondary
        return textField
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        view.addSubview(textField)
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 45),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                containerView
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let iconsTintColor: UIColor
    private let leftImage: UIImage?
    private let cornerRadius: CGFloat
    private let isSecureTextEntry: Bool
    
    init(
        iconsTintColor: UIColor = UIColor.myGray,
        leftImage: UIImage? = nil,
        cornerRadius: CGFloat = 10,
        isSecureTextEntry: Bool = false
    ) {
        
        self.iconsTintColor = iconsTintColor
        self.leftImage = leftImage
        self.cornerRadius = cornerRadius
        self.isSecureTextEntry = isSecureTextEntry
        
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        
        addViewFillEntireView(stackView)
    }
}

