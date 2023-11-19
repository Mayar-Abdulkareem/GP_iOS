//
//  UIImage + extension.swift
//  GP_iOS
//
//  Created by FTS on 18/11/2023.
//

import UIKit

enum ImageName: String {
    case loginImage0 = "0"
    case loginImage1 = "1"
    case loginImage2 = "2"
    case loginImage3 = "3"
    case loginImage4 = "4"
    case loginImage5 = "5"
    case loginBackground = "LoginBackground"
    case eye = "eye"
    case eyeSlash = "eye.slash"
    
    static let loginImagesCases: [ImageName] = [.loginImage0, .loginImage1, .loginImage2, .loginImage3, .loginImage4, .loginImage5]
}

extension UIImage {
    /// Function to create a UIImage from an asset name
    convenience init?(named imageName: ImageName) {
        self.init(named: imageName.rawValue)
    }
    
    convenience init?(systemName imageName: ImageName) {
        self.init(named: imageName.rawValue)
    }
}
