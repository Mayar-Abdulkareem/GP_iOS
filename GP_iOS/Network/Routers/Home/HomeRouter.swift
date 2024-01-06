//
//  HomeRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import Alamofire

enum HomeRouter: BaseRouter {

    // MARK: Cases

    case getProfile(regID: String, role: String)

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .getProfile:
            return "/profileInfo"
        }
    }

    // MARK: Method

    ///  Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .post
        }
    }

    // MARK: Parameters

    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {

        case .getProfile(regID: let regID, role: let role):
            return [
                "regID": regID,
                "role": role
            ]
        }
    }
}
