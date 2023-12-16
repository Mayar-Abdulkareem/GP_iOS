//
//  GetCoursesByRegID.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import Alamofire

protocol CoursesFetching {
    func fetchCourses(with regID: String, completion: @escaping (Result<[Course], AFError>) -> Void)
}

class CoursesFetcher: CoursesFetching {
    private let networkClient: BaseClient
    
    init(networkClient: BaseClient = BaseClient.shared) {
        self.networkClient = networkClient
    }
    
    func fetchCourses(with regID: String, completion: @escaping (Result<[Course], AFError>) -> Void) {
        let route = CoursesRouter.getCourses(regID: regID)
        networkClient.performRequest(router: route, completion: completion)
    }
}

class FetchCoursesUseCase {
    private let coursesFetcher: CoursesFetching
    
    init(coursesFetcher: CoursesFetching = CoursesFetcher()) {
        self.coursesFetcher = coursesFetcher
    }
    
    func execute(with regID: String, completion: @escaping (Result<[Course], AFError>) -> ()) {
        coursesFetcher.fetchCourses(with: regID, completion: completion)
    }
}
