//
//  BoardRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareemm on 06/01/2024.
//

import Alamofire

enum BoardRouter: BaseRouter {

    // MARK: Cases

    case getBoard(regID: String, courseID: String)
    case saveOrder(board: Board)

    // MARK: Paths

    /// Specify the path for each case
    var path: String {
        switch self {
        case .getBoard(regID: let regID, courseID: let courseID):
            return "/boards/getBoard/\(courseID)/\(regID)"
        case .saveOrder:
            return "/boards/saveBoard"
        }
    }

    // MARK: Method

    ///  Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .getBoard:
            return .get
        case .saveOrder:
            return .put
        }
    }

    // MARK: Parameters

    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .getBoard:
            return nil
            //        case .saveOrder(board: let board):
            //            var params: Parameters = [:]
            //            params["regID"] = board.regID
            //            params["courseID"] = board.courseID
            //            params["columns"] = board.columns
            //            params["tasks"] = board.tasks
            //            params["supervisorID"] = board.supervisorID
            //            return params
            //        }
            //    }
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
