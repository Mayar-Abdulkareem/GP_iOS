//
//  CustomTextField.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 09/01/2024.
//

import UIKit

class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

