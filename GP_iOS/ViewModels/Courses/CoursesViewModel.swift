//
//  CoursesViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import Alamofire

enum HomeSections: Int, CaseIterable {
    case header
    case courses
    
    func getTitle() -> String? {
        switch self {
        case .header:
            return nil
        case .courses:
            return "Courses"
        }
    }
}

class CoursesViewModel {
    
    // MARK: - Call Backs
    
    /// If error happens
    var onShowError: ((_ msg: String) -> Void)?
    /// If the fetch courses completed successfully
    var onFetchCourses: (([Course]) -> ())?
    
    var courses = [Course]()
    let sections: [HomeSections] = HomeSections.allCases
    
    // MARK: - UseCases
    
    /// UseCase for fetching user by credential
    private let fetchCourses = FetchCoursesUseCase()
    
    // MARK: - Methods
    
    func getData() {
        let regID = UserDefaults.standard.string(forKey: "regID") ?? ""
        fetchCourses(with: regID)
    }
    
    /// Fetch courses by regID
    func fetchCourses(with regID: String) {
        fetchCourses.execute(with: regID) { [weak self] result in
            switch result {
            case .success(let courses):
                self?.courses = courses
                self?.onFetchCourses?(courses)
                
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
    
    func getCellModel(index: Int) -> HomeTableViewCellModel {
        let course = courses[index]
        
        let isOdd = index % 2 != 0
        
        return HomeTableViewCellModel(
            name: course.courseName,
            supervisor: course.supervisorName,
            background: isOdd ? UIColor.mySecondary : .white,
            titleColor: isOdd ? .white : UIColor.myAccent
        )
    }
}
