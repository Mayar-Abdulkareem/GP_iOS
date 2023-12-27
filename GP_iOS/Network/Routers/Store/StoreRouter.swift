//
//  StoreRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulakreem on 24/12/2023.
//

import Alamofire

enum StoreRouter: BaseRouter {
    
    // MARK: Cases
    
    /// Get previous projects
    case getAllItems(storeFilterModel: StoreFilterModel)
    case deleteItem(id: String)
    case updateItem(item: Item)
    case addItem(item: Item)
    
    // MARK: Paths
    
    /// Specify the path for each case
    var path: String {
        switch self {
        case .getAllItems:
            return "/store"
        case .deleteItem(id: let id):
            return "/store/\(id)"
        case .updateItem(item: let item):
            return "/store/update/\(item.id)"
        case .addItem:
            return "/store/addItem"
        }
    }
    
    // MARK: Method
    
    /// Specify the HTTP method for each case
    var method: HTTPMethod {
        switch self {
        case .getAllItems:
            return .post
        case .deleteItem:
            return .delete
        case .updateItem:
            return .post
        case .addItem:
            return .post
        }
    }
    
    // MARK: Parameters
    
    /// Provide parameters for the request, if applicable
    var parameters: Parameters? {
        switch self {
        case .getAllItems(let storeFilterModel):
            var params: Parameters = ["page": storeFilterModel.page]
            
            if let projectName = storeFilterModel.title {
                params["title"] = projectName
            }
            
            if let regID = storeFilterModel.regID {
                params["regID"] = regID
            }
            
            if let sortByDate = storeFilterModel.sortByPrice {
                params["sortByPrice"] = sortByDate
            }
            
            return params
        case .deleteItem:
            return nil
        case .updateItem(item: let item):
            return buildParams(from: item)
            
        case .addItem(item: let item):
            var params = buildParams(from: item)
            params["regID"] = item.id
            return params
        }
    }
    
    func buildParams(from item: Item) -> Parameters {
        var params: Parameters = [:]
        if let title = item.title { params["title"] = title }
        if let price = item.price { params["price"] = price }
        if let location = item.location { params["location"] = location }
        if let quantity = item.quantity { params["quantity"] = quantity }
        if let showPhoneNumber = item.showPhoneNumber { params["showPhoneNumber"] = showPhoneNumber }
        return params
    }
}
