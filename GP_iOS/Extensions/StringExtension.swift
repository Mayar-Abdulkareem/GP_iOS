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
        
        /// Top Alert
        /// - Title:
        case infoTitle
        case errorTitle
        /// - Subtitle:
        case fillAllFieldsMsg
        case unauthenticatedSubtitle
        /// Tab Bar Menue
        /// - Title:
        case homeTitle
        case searchTitle
        case storeTitle
        case moreTitle
        case profileTitle
        case registerTitle
        case announcementTitle
        case logoutTitle
        
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
