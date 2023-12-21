////
////  GetUserByIdAndPassword.swift
////  GP_iOS
////
////  Created by Mayar Abdulkareem on 09/12/2023.
////
//
//import Alamofire
//
//protocol UserFetching {
//    func fetchUser(credential: Credential, completion: @escaping (Result<AccessToken, AFError>) -> Void)
//}
//
//class UserFetcher: UserFetching {
//    private let networkClient: BaseClient
//    
//    init(networkClient: BaseClient = BaseClient.shared) {
//        self.networkClient = networkClient
//    }
//    
//    func fetchUser(credential: Credential, completion: @escaping (Result<AccessToken, Alamofire.AFError>) -> Void) {
//        let route = LoginRouter.login(credential: credential)
//        networkClient.performRequest(router: route, completion: completion)
//    }
//}
//
//class FetchUserUseCase {
//    private let userFetcher: UserFetching
//    
//    init(userFetcher: UserFetching = UserFetcher()) {
//        self.userFetcher = userFetcher
//    }
//    
//    func execute(with credential: Credential, completion: @escaping (Result<AccessToken, AFError>) -> ()) {
//        userFetcher.fetchUser(credential: credential, completion: completion)
//    }
//}
