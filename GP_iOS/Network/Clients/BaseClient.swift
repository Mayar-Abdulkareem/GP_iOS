//
//  BaseClient.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 06/11/2023.
//

import Alamofire
import UIKit

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
     - completion: A closure to be executed when the request completes, providing a `Result` with the decoded data or an
     `AFError` in case of failure.
     */
    func performRequest<T: Codable> (
        // type: T.Type,
        router: BaseRouter,
        type: T.Type,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(router)
            .validate()
            .responseDecodable { (response: DataResponse<T, AFError>) in
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
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

    func uploadImage<T: Codable>(
        image: UIImage?,
        router: BaseRouter,
        type: T.Type,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.upload(
            multipartFormData: { multipartFormData in

                if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "image", fileName: "file.jpg", mimeType: "image/jpeg")
                }

                if let parameters = router.parameters {
                    for (key, value) in parameters {
                        if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        } else if let boolValue = value as? Bool {
                            let data = Data("\(boolValue)".utf8)
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }
            },
            with: router)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
