//
//  UIViewExtension.swift
//  GP_iOS
//
//  Created by FTS on 21/11/2023.
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
}

