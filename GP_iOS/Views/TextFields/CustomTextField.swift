//
//  CustomTextField.swift
//  GP_iOS
//
//  Created by FTS on 19/11/2023.
//

import UIKit

class CustomTextField: UITextField {
    
    init(withPlaceHolder placeHolderText: String) {
        super.init(frame: .zero)
        placeholder = placeHolderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTextField()
    }
    
    /// congigure the CustomTextField
    private func setupTextField() {
        
        // border
        borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: frame.size.height + 10, width: frame.size.width, height: 1.0)
        if let color = UIColor(named: .gray) {
            bottomLine.backgroundColor = color.cgColor
        } else {
            bottomLine.backgroundColor = UIColor.black.cgColor
        }
        layer.addSublayer(bottomLine)
        
        // cursor color
        if let cursorColor = UIColor(named: .secondary) {
            tintColor = cursorColor
        } else {
            tintColor = .black
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insetRect = bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        return super.textRect(forBounds: insetRect)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetRect = bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        return super.editingRect(forBounds: insetRect)
    }
}
