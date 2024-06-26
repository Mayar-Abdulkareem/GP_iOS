//
//  CustomButton.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 19/11/2023.
//

import UIKit

class CustomButton: UIButton {

    convenience init(buttonText: String) {
        self.init(type: .system)
        setUpButton(buttonText: buttonText)
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
