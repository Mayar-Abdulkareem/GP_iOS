//
//  UIImage + extension.swift
//  GP_iOS
//
//  Created by FTS on 18/11/2023.
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
        
        ///  Get image
        var image: UIImage {
            return UIImage(systemImages: self)
        }
    }
    
    private convenience init!(systemImages: SystemImages) {
        self.init(systemName: systemImages.rawValue)
    }
}

