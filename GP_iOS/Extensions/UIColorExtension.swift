//
//  UIColorExtension.swift
//  GP_iOS
//
//  Created by FTS on 18/11/2023.
//

import UIKit

enum ColorName: String {
    case secondary = "Secondary"
    case primary = "Primary"
    case accent = "Accent"
    case gray = "Gray"
}

extension UIColor {
    /// Function to create a UIColor from an asset name
    convenience init(named colorName: ColorName) {
        self.init(named: colorName.rawValue)!
    }
}
