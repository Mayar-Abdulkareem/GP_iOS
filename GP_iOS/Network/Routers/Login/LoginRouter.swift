//
//  LoginRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 06/11/2023.
//

import Alamofire

struct Credential {
    let regID: String
    let password: String
}

enum LoginRouter: BaseRouter {
    
    // MARK: Cases
    
    ///  Login
    case login(credential: Credential)
    
    // MARK: Paths
    
    /// Specify the path for each case
    var path: String {
        switch self {
        case .login:
            return "/login"
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
        case .login(credential: let credential):
            return [
                "regID": credential.regID,
                "password": credential.password
            ]
        }
    }
}
