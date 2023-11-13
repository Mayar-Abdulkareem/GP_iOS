//
//  BaseRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 06/11/2023.
//

import Foundation
import Alamofire

/// Protocol for API routers
protocol BaseRouter: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

