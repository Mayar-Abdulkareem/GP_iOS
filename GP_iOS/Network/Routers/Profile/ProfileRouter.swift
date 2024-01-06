//
//  ProfileRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 06/01/2024.
//

import Foundation

import Alamofire

enum ProfileRouter: BaseRouter {

    // MARK: Cases

    case updateProfilePic(regID: String)
    case deleteProfilePic(regID: String)

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .updateProfilePic:
            return "/profileInfo/editProfileImage"
        case .deleteProfilePic:
            return "/profileInfo/removeProfileImage"
        }
    }

    // MARK: Method

    ///  Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .updateProfilePic:
            return .put
        case .deleteProfilePic:
            return .put
        }
    }

    // MARK: Parameters

    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .updateProfilePic(regID: let regID):
            return [
                "regID": regID
            ]
        case .deleteProfilePic(regID: let regID):
            return [
                "regID": regID
            ]
        }
    }
}
