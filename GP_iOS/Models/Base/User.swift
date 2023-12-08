//
//  User.swift
//  GP_iOS
//
//  Created by FTS on 06/11/2023.
//

import Foundation
import Alamofire

protocol User {
    var regNumber: String { get set }
    var password: String { get set }
}
