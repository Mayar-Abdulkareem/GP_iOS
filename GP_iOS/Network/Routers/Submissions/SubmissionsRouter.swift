//
//  SubmissionsRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 21/01/2024.
//

import Foundation

import Alamofire

enum SubmissionsRouter: BaseRouter {

    // MARK: Cases

    case getAssignments(courseID: String)
    case getSubmission(studentID: String, courseID: String, assignmentID: String)
    case addSubmission(mySubmission: MySubmission)
    case deleteSubmission(submissionID: String)
    case editText(submissionId: String, text: String)

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .getAssignments:
            return "/assignments"
        case .getSubmission:
            return "/submissions/getSubmissionDetails"
        case .addSubmission:
            return "/submissions/addSubmission"
        case .deleteSubmission(submissionID: let submissionID):
            return "/submissions/\(submissionID)"
        case .editText:
            return "/submissions/editText"
        }
    }

    // MARK: Method

    /// Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .getAssignments:
            return .post
        case .getSubmission:
            return .post
        case .addSubmission:
            return .post
        case .deleteSubmission:
            return .delete
        case .editText:
            return .post
        }
    }

    // MARK: Parameters

    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .getAssignments(courseID: let courseID):
            return [
                "courseID": courseID
            ]
        case .getSubmission(studentID: let studentID, courseID: let courseID, assignmentID: let assignmentID):
            return [
                "studentID": studentID,
                "courseID": courseID,
                "assignmentID": assignmentID
            ]
        case .addSubmission:
            return nil
        case .deleteSubmission:
            return nil
        case .editText(submissionId: let submissionId, text: let text):
            return [
                "submissionId": submissionId,
                "newText": text
            ]
        }
    }
}
