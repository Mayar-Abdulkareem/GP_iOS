//
//  StringExtension.swift
//  GP_iOS
//
//  Created by FTS on 22/11/2023.
//

import Foundation

extension String {
    
    enum LocalizedKeys: String.LocalizationValue {
        case welcomeMessage
        case registrationIDTextFieldText
        case passwordTextFieldText
        case loginButtonKey
        case logoText
        
        var localized: String {
            return String(localizedKey: self)
        }
        // I can use NSLocalized instead of string(localized)
        //        var localized: String {
        //            return NSLocalizedString(rawValue, comment: "")
        //        }
    }
    
    private init!(localizedKey: LocalizedKeys){
        self.init(localized: localizedKey.rawValue)
    }
}
