//
//  CustomTextField.swift
//  GP_iOS
//
//  Created by FTS on 19/11/2023.
//

import UIKit

class CustomTextField: UITextField {
    
    lazy var inset: UIEdgeInsets = {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }()
    
    init(withPlaceHolder placeHolderText: String, isPassword: Bool = false) {
        super.init(frame: .zero)
        placeholder = placeHolderText
        if isPassword {
            inset.right = 45
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTextField()
    }
    
    /// configure the CustomTextField
    private func setupTextField() {
        // border
        borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: frame.size.height + 10, width: frame.size.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.myGray.cgColor
        layer.addSublayer(bottomLine)
    
        // cursor color
        tintColor = UIColor.mySecondary
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
}
