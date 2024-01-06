//
//  RegisterRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 01/01/2024.
//

import Alamofire

enum RegisterRouter: BaseRouter {

    // MARK: Cases

    case getAvailableCourses(regID: String)
    case getAvailableSupervisors(courseID: String)
    case postRequestForSupervisor(request: Request)
    case deleteRequestFirSupervisor(studentID: String)
    case getRequest(studentID: String)
    case getCategories(courseID: String)
    case registerCourse(studentID: String, courseID: String, skillsVector: String)

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .getAvailableCourses(let regID):
            return "/availableCourses/\(regID)"
        case .getAvailableSupervisors(let courseId):
            return "/availableProfessors/\(courseId)"
        case .postRequestForSupervisor:
            return "/request/supervisor"
        case .deleteRequestFirSupervisor(studentID: let studentID):
            return "/requests/supervisorRequest/\(studentID)"
        case .getRequest:
            return "/requests/student"
        case .getCategories(courseID: let courseID):
            return "/tags/student/\(courseID)"
        case .registerCourse:
            return "/requests/registerCourse"
        }
    }

    // MARK: Method

    /// Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .getAvailableCourses:
            return .get
        case .getAvailableSupervisors:
            return .get
        case .postRequestForSupervisor:
            return .post
        case .deleteRequestFirSupervisor:
            return .delete
        case .getRequest:
            return .post
        case .getCategories:
            return .get
        case .registerCourse:
            return .put
        }
    }

    // MARK: Parameters

    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .getAvailableCourses:
            return nil
        case .getAvailableSupervisors:
            return nil
        case .postRequestForSupervisor(request: let request):
            return [
                "senderID": request.senderID,
                "receiverID": request.receiverID,
                "courseID": request.courseID
            ]
        case .deleteRequestFirSupervisor:
            return nil
        case .getRequest(studentID: let studentID):
            return [
                "studentID": studentID,
            ]
        case .getCategories:
            return nil
        case .registerCourse(let studentID, let courseID, let skillsVector):
            return [
                "regID": studentID,
                "courseID": courseID,
                "skillsVector": skillsVector
            ]
        }
    }
}
