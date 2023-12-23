//
//  SearchRoute.swift
//  GP_iOS
//
//  Created by FTS on 16/12/2023.
//

// MARK: - SearchRouter

import Alamofire

enum SearchRouter: BaseRouter {
    
    // MARK: Cases
    
    /// Get previous projects
    case getPrevProjects(searchFilterModel: SearchFilterModel)
    case getProjectTypes
    
    // MARK: Paths
    
    /// Specify the path for each case
    var path: String {
        switch self {
        case .getPrevProjects:
            return "/previousProjects"
        case .getProjectTypes:
            return "/previousProjects/projectTypes"
        }
    }
    
    // MARK: Method
    
    /// Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .getPrevProjects:
            return .post
        case .getProjectTypes:
            return .get
        }
    }
    
    // MARK: Parameters
    
    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .getPrevProjects(let searchFilterModel):
            var params: Parameters = ["page": searchFilterModel.page]
            
            if let projectName = searchFilterModel.projectName {
                params["projectName"] = projectName
            }
            
            //if let projectType = searchFilterModel.projectType {
            params["projectType"] = searchFilterModel.projectType
            //}
            
            if let sortByDate = searchFilterModel.sortByDate {
                params["sortByDate"] = sortByDate
            }
            
            return params
        case .getProjectTypes:
            return nil
        }
    }
}
