//
//  UITextField+Extension.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 21/01/2024.
//

import UIKit.UITextField

extension UITextField {
    func addKeyboardToolbarDoneButton(rightButtonSelector: Selector,
                                      target: Any) {
        let toolBar =  UIToolbar(frame: CGRect(x: 0.0,
                                               y: 0.0,
                                               width: UIScreen.main.bounds.size.width,
                                               height: 44.0))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: rightButtonSelector)
        doneButton.tintColor = UIColor.black
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
}
