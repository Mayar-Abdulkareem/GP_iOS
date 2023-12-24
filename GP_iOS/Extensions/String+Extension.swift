//
//  String+Extension.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/11/2023.
//

import Foundation

extension String {
    
    enum LocalizedKeys: String.LocalizationValue {
        case welcomeMessage
        case registrationIDTextFieldText
        case passwordTextFieldText
        case loginButtonKey
        case logoText
        case noCourses
        case noPrevProjects
        case noMoreResultsMsg
        case clearTitle
        case filterTitle
        case viewMoreTitle
        case studentsTitle
        case supervisorTitle
        case doctorInitital
        case searchByProjectName
        
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
        case courseTitle
        case previousProjectTitle
        case storeTitle
        case moreTitle
        case profileTitle
        case registerTitle
        case announcementTitle
        case logoutTitle
        
        /// Project List
        case choosePeerTitle
        case boardTitle
        case submissionTitle
        
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
