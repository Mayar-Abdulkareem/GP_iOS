//
//  UIView+Extension.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 21/11/2023.
//

import UIKit

extension UIView {
    /**
     Adds a subview and sets constraints to make it fill the entire parent view with specified padding.
     - Parameters:
      - viewToAdd: The view to be added as a subview.
      - top: The top padding.
      - bottom: The bottom padding.
      - leading: The leading (left) padding.
      - trailing: The trailing (right) padding.
     */
    func addViewFillEntireView(
        _ viewToAdd: UIView,
        top: CGFloat = 0,
        bottom: CGFloat = 0,
        leading: CGFloat = 0,
        trailing: CGFloat = 0
    ) {
        
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewToAdd)
        
        NSLayoutConstraint.activate([
            viewToAdd.topAnchor.constraint(equalTo: self.topAnchor, constant: top),
            viewToAdd.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottom),
            viewToAdd.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leading),
            viewToAdd.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -trailing)
        ])
    }
    
    func addViewWithConstant(
        _ viewToAdd: UIView,
        constant: CGFloat
    ) {
        
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewToAdd)
        
        NSLayoutConstraint.activate([
            viewToAdd.topAnchor.constraint(equalTo: self.topAnchor, constant: constant),
            viewToAdd.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant),
            viewToAdd.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant),
            viewToAdd.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant)
        ])
    }
    
    func addShadow(
        cornerRadius: CGFloat = 10,
        shadowColor: UIColor = UIColor.gray,
        shadowOpacity: Float = 0.2,
        shadowOffset: CGSize = CGSize(width: 0, height: 0),
        shadowRadius: CGFloat = 8
    ) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
}

