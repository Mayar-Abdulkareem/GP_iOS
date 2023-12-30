//
//  HomeViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import Alamofire
import UIKit

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

class HomeViewModel {

    // MARK: - Call Backs

    /// If error happens
    var onShowError: ((_ msg: String) -> Void)?
    /// If the fetch courses completed successfully
    var onCoursesFetched: (([Course]) -> Void)?

    var courses = [Course]()
    let sections: [HomeSections] = HomeSections.allCases
    let courseCollectionViewCell = [
        CourseCollectionViewCellModel(
            title: String.LocalizedKeys.choosePeerTitle.localized,
            icon: UIImage.SystemImages.choosePeer.image
        ),
        CourseCollectionViewCellModel(
            title: String.LocalizedKeys.boardTitle.localized,
            icon: UIImage.SystemImages.board.image
        ),
        CourseCollectionViewCellModel(
            title: String.LocalizedKeys.submissionTitle.localized,
            icon: UIImage.SystemImages.submission.image
        )
    ]

    // MARK: - Methods

    func getData() {
        let regID = UserDefaults.standard.string(forKey: "regID") ?? ""
        fetchCourses(with: regID)
    }

    /// Fetch courses by regID
    func fetchCourses(with regID: String) {
        let route = CoursesRouter.getCourses(regID: regID)
        BaseClient.shared.performRequest(router: route, type: [Course].self) { [weak self] result in
            switch result {
            case .success(let courses):
                self?.courses = courses
                self?.onCoursesFetched?(courses)

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
            titleColor: isOdd ? .white : UIColor.myAccent,
            subTitleColor: isOdd ? .myGray : .gray
        )
    }
}
