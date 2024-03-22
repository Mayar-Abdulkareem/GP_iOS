//
//  StringManager.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/12/2023.
//

import UIKit

class StringManager {
    static let shared = StringManager()

    private init() {}

    func createAttributedText(prefix: String, value: String?) -> NSAttributedString {
        let fullText = prefix + (value ?? "")
        let attributedString = NSMutableAttributedString(string: fullText)

        if let value = value {
            let range = (fullText as NSString).range(of: value)
            attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: range)
        }

        return attributedString
    }
}
