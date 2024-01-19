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
        }
    }

    // MARK: Method

    /// Specify the HTTP method for each case
    var method: HTTPMethod {
        return .put
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
        }
    }
}
