//
//  UICollectionView+Extension.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/12/2023.
//

import UIKit

extension UICollectionView {

    func setEmptyView(message: String) {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.sizeToFit()
        messageLabel.center = emptyView.center

        messageLabel.frame.origin.y = 50

        emptyView.addSubview(messageLabel)

        backgroundView = emptyView
    }

    func removeEmptyView() {
        backgroundView = nil
    }
}
