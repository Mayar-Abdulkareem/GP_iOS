//
//  CoursesRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import Alamofire

enum CoursesRouter: BaseRouter {

    // MARK: Cases

    ///  Login
    case getCourses(regID: String)

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .getCourses(let regID):
            return "/registeredCourses/\(regID)"
        }
    }

    // MARK: Method

    ///  Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .getCourses:
            return .get
        }
    }

    // MARK: Parameters

    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .getCourses:
            return nil
        }
    }
}
