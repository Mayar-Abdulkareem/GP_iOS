//
//  UserRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 06/11/2023.
//


import Alamofire


enum UserType {
    case student(Student)
    case teacher(Teacher)
    case administrator(Administrator)
}

enum LoginRouter: BaseRouter {
    
    // MARK: Cases
    
    ///  Login
    case login(userType: UserType)
    
    ///  Get Info
    case getUserInfo(userType: UserType)
    
    // MARK: Paths
    
    /// Specify the path for each case
    var path: String {
        switch self {
        case .login(userType: let userType):
            switch userType {
            case .student:
                return "student"
            case .teacher:
                return "teacher"
            case .administrator:
                return "administrator"
            }
        case .getUserInfo(userType: let userType):
            switch userType {
            case .student:
                return "student"
            case .teacher:
                return "teacher"
            case .administrator:
                return "administrator"
            }
        }
    }
    
    // MARK: Method
    
    ///  Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getUserInfo:
            return .get
        }
    }
    
    // MARK: Parameters
    
    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .login(userType: let userType):
            switch userType {
            case .student(let student):
                return [
                    "regNumber": student.regNumber,
                    "password": student.password
                ]
            case .teacher(let teacher):
                return [
                    "regNumber": teacher.regNumber,
                    "password": teacher.password
                ]
            case .administrator(let admin):
                return [
                    "regNumber": admin.regNumber,
                    "password": admin.password
                ]
            }
        default:
            return nil
        }
    }
    
    /// Implement the URLRequestConvertible method
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: NetworkConstant.loginBaseURL.asURL()
            .appendingPathComponent(path)
            .absoluteString.removingPercentEncoding!)

        var request = URLRequest.init(url: url!)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try URLEncoding.default.encode(request,with: parameters)
    }
}

