//
//  UserRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 06/11/2023.
//


import Alamofire

enum LoginRouter: BaseUnitRouter {
    
    // MARK: Cases
    
    ///  Login
    case login(regNumber: String, password: String)
    
    // MARK: Paths
    
    /// Specify the path for each case
    var path: String {
        switch self {
        case .login:
            return "user/login"
        }
    }
    
    // MARK: Method
    
    ///  Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    // MARK: Parameters
    
    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .login(regNumber: let regNumber, password: let password):
            return [
                "regNumber": regNumber,
                "password": password
            ]
        }
    }
}
