//
//  PeerRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/01/2024.
//

import Alamofire

enum PeerRouter: BaseRouter {

    // MARK: Cases

    case sendPeerRequest(regID: String, peerID: String)
    case cancelPeerRequest(regID: String)
    case matchWithSameSkills(regID: String, courseID: String)
    case matchWithOppositeSkills(regID: String, courseID: String)
    case matchWithCustommSkills(regID: String, courseID: String, studentVector: String)

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .sendPeerRequest:
            return "/requests/sendPeerRequest"
        case .cancelPeerRequest:
            return "/requests/cancelPeerRequest"
        case .matchWithSameSkills:
            return "/peerMatching/sameSkills"
        case .matchWithOppositeSkills:
            return "/peerMatching/oppositeSkills"
        case .matchWithCustommSkills:
            return "/peerMatching/customSkills"
        }
    }

    // MARK: Method

    /// Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .sendPeerRequest:
            return .put
        case .cancelPeerRequest:
            return .put
        case .matchWithSameSkills:
            return .post
        case .matchWithOppositeSkills:
            return .post
        case .matchWithCustommSkills:
            return .post
        }
    }

    // MARK: Parameters

    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .sendPeerRequest(regID: let regID, peerID: let peerID):
            return [
                "senderID": regID,
                "receiverID": peerID
            ]
        case .cancelPeerRequest(regID: let regID):
            return [
                "senderID": regID
            ]
        case .matchWithSameSkills(regID: let regID, courseID: let courseID):
            return [
                "regID": regID,
                "courseID": courseID
            ]
        case .matchWithOppositeSkills(regID: let regID, courseID: let courseID):
            return [
                "regID": regID,
                "courseID": courseID
            ]
        case .matchWithCustommSkills(regID: let regID, courseID: let courseID, studentVector: let studentVector):
            return [
                "regID": regID,
                "courseID": courseID,
                "studentVector": studentVector
            ]
        }
    }
}
