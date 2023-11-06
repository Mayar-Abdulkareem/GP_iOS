//
//  BaseClient.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 06/11/2023.
//

import Foundation
import Alamofire

class BaseClient {
    static let shared = BaseClient()
    
    func performRequest<T: Codable> (
        router: BaseRouter,
        completion: @escaping (Result<T, AFError>) -> ()) {
            AF.request(router)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
}
