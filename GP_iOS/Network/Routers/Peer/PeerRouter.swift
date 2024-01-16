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

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .sendPeerRequest:
            return "/requests/sendPeerRequest"
        case .cancelPeerRequest(regID: let regID):
            return "/requests/cancelPeerRequest"
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
        }
    }
}
