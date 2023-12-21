//
//  BaseRouter.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 06/11/2023.
//

import Alamofire

/// Protocol for API routers
protocol BaseRouter: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

extension BaseRouter {
    
    var defaultHeaders: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
    /// Returns a URLRequest object based an the provided path, method, and parameter
    func asURLRequest() throws -> URLRequest {
        let url = try (BuildConfiguration.shared.baseURL +
                              self.path).asURL()
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.headers = defaultHeaders
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(
                    withJSONObject: parameters,
                    options: [])
            } catch {
                throw AFError.parameterEncodingFailed(
                    reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}
