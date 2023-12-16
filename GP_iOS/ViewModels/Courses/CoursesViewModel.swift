//
//  CoursesViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import Alamofire

class CoursesViewModel {
    
    // MARK: - Call Backs
    
    /// If error happens
    var onShowError: ((_ msg: String) -> Void)?
    /// If the fetch courses completed successfully
    var onFetchCourses: (([Course]) -> ())?
    
    // MARK: - UseCases
    
    /// UseCase for fetching user by credential
    private let fetchCourses = FetchCoursesUseCase()
    
    // MARK: - Methods
    
    /// Fetch courses by regID
    func fetchCourses(with regID: String) {
        fetchCourses.execute(with: regID) { [weak self] result in
            switch result {
            case .success(let courses):
                self?.onFetchCourses?(courses)
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
