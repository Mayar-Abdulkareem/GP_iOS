//
//  CustomButton.swift
//  GP_iOS
//
//  Created by FTS on 19/11/2023.
//

import UIKit

class CustomButton: UIButton {
    
    init(buttonText: String) {
        super.init(frame: .zero)
        setUpButton(buttonText: buttonText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton(buttonText: String) {
        setTitle(buttonText, for: .normal)
        setTitleColor(UIColor.myPrimary, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        backgroundColor = UIColor.mySecondary
        layer.cornerRadius = 8
        heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
