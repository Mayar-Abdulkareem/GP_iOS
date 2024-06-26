//
//  UIImage+Extension.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 18/11/2023.
//

import UIKit

extension UIImage {
    enum SystemImages: String {

        /// Login
        case fillEye = "eye.fill"
        case slashFillEye = "eye.slash.fill"
        case number
        case lock = "lock.fill"

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
        case viewMore = "chevron.right"

        /// Project Details
        case supervisor = "person.crop.circle.badge.checkmark"
        case year = "calendar"
        case projectType = "doc.text"

        /// Store and Item details
        case cart = "cart.fill"
        case price = "shekelsign"
        case location = "location"
        case email = "envelope"
        case phone = "phone"
        case trash = "trash"
        case copy = "doc.on.doc"
        case name = "person"
        case circle
        case circleFill = "circle.fill"
        case document = "doc.plaintext"
        case plus
        case minus

        /// Register
        case openLock = "lock.open"
        case closeLock = "lock"

        /// Profile
        case personFill = "person.circle.fill"
        case regID = "rectangle.and.pencil.and.ellipsis"
        case GPA = "medal"
        case camera = "camera.fill"

        /// Peer
        case pencil = "pencil"

        /// Requests
        case requests = "envelope.badge.person.crop"

        /// Submission
        case status = "questionmark.circle"
        case uploadedText = "text.bubble"
        case uploadedFile = "arrow.down.app"
        case upload = "arrow.up.square"

        ///  Get image
        var image: UIImage {
            return UIImage(systemImages: self)
        }
    }

    private convenience init!(systemImages: SystemImages) {
        self.init(systemName: systemImages.rawValue)
    }
}
