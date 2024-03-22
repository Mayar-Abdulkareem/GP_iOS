//
//  BoardRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareemm on 06/01/2024.
//

import Alamofire

enum BoardRouter: BaseRouter {

    // MARK: Cases

    case getBoard(regID: String, courseID: String, supervisorID: String)
    case saveOrder(board: Board)

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .getBoard:
            return "/boards/getBoard"
        case .saveOrder:
            return "/boards/saveBoard"
        }
    }

    // MARK: Method

    ///  Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .getBoard:
            return .post
        case .saveOrder:
            return .put
        }
    }

    // MARK: Parameters

    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .getBoard(regID: let regID, courseID: let courseID, supervisorID: let supervisorID):
            return [
                "regID" : regID,
                "courseID" : courseID,
                "supervisorID" : supervisorID
            ]
        case .saveOrder(board: let board):
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(board),
               let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) as? [String: Any] {
                return dictionary
            }
            return nil
        }
    }
}
