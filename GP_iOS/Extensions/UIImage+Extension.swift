//
//  UIImage+Extension.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 18/11/2023.
//

import UIKit

extension UIImage {
    enum SystemImages: String {
        
        /// Password
        case fillEye = "eye.fill"
        case slashFillEye = "eye.slash.fill"
        /// TopAlert
        case check = "checkmark.circle.fill"
        case xmark = "xmark.circle.fill"
        case info = "info.circle.fill"
        /// Logo
        case graduationCap = "graduationcap"
        /// Tab Bar Menue
        case home = "house.fill"
        case search = "doc.text.magnifyingglass"
        case store = "storefront.fill"
        case more = "circle.grid.2x2.fill"
        /// More
        case profile = "person.fill"
        case register = "square.and.pencil"
        case announcement = "bell.and.waves.left.and.right.fill"
        case logout = "power.circle"
        /// Project List
        case choosePeer = "person.2"
        case board = "list.bullet.clipboard"
        case submission = "paperplane"
        /// Navigation Bar
        case notification = "bell"
        case chat = "ellipsis.message"
        /// Filter
        case filter = "line.3.horizontal.decrease.circle"
        case filterFill = "line.3.horizontal.decrease.circle.fill"
        case selectedFilter = "checkmark.circle"
        /// Search
        case viewMore = "greaterthan"
        /// Project Details
        case supervisor = "person.crop.circle.badge.checkmark"
        case year = "calendar"
        case projectType = "doc.text"
        ///  Get image
        var image: UIImage {
            return UIImage(systemImages: self)
        }
    }
    
    private convenience init!(systemImages: SystemImages) {
        self.init(systemName: systemImages.rawValue)
    }
}

