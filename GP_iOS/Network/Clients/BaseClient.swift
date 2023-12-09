//
//  BaseClient.swift
//  GP_iOS
//
//  Created by FTS on 06/11/2023.
//

import Alamofire

/// `BaseClient` is a singleton class responsible for making network requests using Alamofire.
class BaseClient {
    /// Shared instance of `BaseClient` that can be used throughout the application.
    static let shared = BaseClient()
    
    /// Private initializer to ensure only one instance of `BaseClient` is created.
    private init() {}
    
    /**
     Performs a network request using Alamofire.
     - Parameters:
      - router: The router that defines the API endpoint, method, and parameters.
      - completion: A closure to be executed when the request completes, providing a `Result` with the decoded data or an `AFError` in case of failure.
     */
    func performRequest<T: Codable> (
        //type: T.Type,
        router: BaseRouter,
        completion: @escaping (Result<T, AFError>) -> ()
    ) {
        AF.request(router)
            .validate()
            .responseDecodable {
                (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("Response JSON: \(jsonString)")
                    }
                    completion(.failure(error))
                }
            }
    }
}
