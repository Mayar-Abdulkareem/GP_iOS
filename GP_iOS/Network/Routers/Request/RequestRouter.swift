//
//  RequestRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 19/01/2024.
//

import Alamofire

enum RequestRouter: BaseRouter {

    // MARK: Cases

    case getPeerRequests(regID: String)
    case acceptPeerRequest(regID: String, peerID: String)
    case declinePeerRequest(peerID: String)
    case updateSkillsVector(regID: String, skillsVector: String)
    case getSupervisorRequests(receiverID: String, courseID: String)
    case acceptSupervisorRequest(senderID: String, receiverID: String, courseID: String)
    case declineSupervisorRequest(studentID: String)

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .getPeerRequests:
            return "/requests/getPeerRequests"
        case .acceptPeerRequest:
            return "/requests/acceptPeerRequest"
        case .declinePeerRequest:
            return "/requests/declinePeerRequest"
        case .updateSkillsVector:
            return "/student/updateSkillsVector"
        case .getSupervisorRequests:
            return "/requests/getSupervisorRequests"
        case .acceptSupervisorRequest:
            return "/requests/acceptSupervisorRequest"
        case .declineSupervisorRequest(let studentID):
            return "/requests/declineSupervisorRequest/\(studentID)"
        }
    }

    // MARK: Method

    /// Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .declineSupervisorRequest:
            return .delete
        default:
            return .put
        }
    }

    // MARK: Parameters

    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .getPeerRequests(regID: let regID):
            return ["receiverID": regID]
        case .acceptPeerRequest(regID: let regID, peerID: let peerID):
            return [
                "senderID": peerID,
                "receiverID": regID
            ]
        case .declinePeerRequest(peerID: let peerID):
            return [
                "senderID": peerID
            ]
        case .updateSkillsVector(regID: let regID, skillsVector: let skillsVector):
            return [
                "regID": regID,
                "skillsVector": skillsVector
            ]
        case .getSupervisorRequests(receiverID: let receiverID, courseID: let courseID):
            return [
                "receiverID": receiverID,
                "courseID": courseID
            ]
        case .acceptSupervisorRequest(senderID: let senderID, receiverID: let receiverID, courseID: let courseID):
            return [
                "senderID": senderID,
                "receiverID": receiverID,
                "courseID": courseID
            ]
        case .declineSupervisorRequest:
            return nil
        }
    }
}
