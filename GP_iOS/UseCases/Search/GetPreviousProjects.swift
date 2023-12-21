////
////  GetPreviousProjects.swift
////  GP_iOS
////
////  Created by FTS on 16/12/2023.
////
//
//import Alamofire
//
//protocol PrevProjectFetching {
//    func fetchPrevProjects(searchFilterModel: SearchFilterModel, completion: @escaping (Result<ProjectResponse, AFError>) -> Void)
//}
//
//class PrevProjectsFetcher: PrevProjectFetching {
//    private let networkClient: BaseClient
//    
//    init(networkClient: BaseClient = BaseClient.shared) {
//        self.networkClient = networkClient
//    }
//    
//    func fetchPrevProjects(searchFilterModel: SearchFilterModel, completion: @escaping (Result<ProjectResponse, AFError>) -> Void) {
//        let route = SearchRouter.getPrevProjects(searchFilterModel: searchFilterModel)
//        networkClient.performRequest(router: route, completion: completion)
//    }
//}
//
//class FetchPrevProjectsUseCase {
//    private let prevProjectsFetcher: PrevProjectFetching
//    
//    init(prevProjectsFetcher: PrevProjectsFetcher = PrevProjectsFetcher()) {
//        self.prevProjectsFetcher = prevProjectsFetcher
//    }
//    
//    func execute(searchFilterModel: SearchFilterModel, completion: @escaping (Result<ProjectResponse, AFError>) -> ()) {
//        prevProjectsFetcher.fetchPrevProjects(searchFilterModel: searchFilterModel, completion: completion)
//    }
//}
