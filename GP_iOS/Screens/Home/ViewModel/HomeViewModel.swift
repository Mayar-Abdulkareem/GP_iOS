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
    var onProfileFetched: ((_ noCourses: Bool) -> Void)?

    var profile: StudentProfile?
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

    func getProfile() {
        guard let regID = AuthManager.shared.regID,
              let role = AuthManager.shared.role else { return }
        let route = HomeRouter.getProfile(regID: regID, role: role)
        BaseClient.shared.performRequest(router: route, type: StudentProfile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                AppManager.shared.profile = profile
                SendBirdManager.shared.connectUser()
                if profile.courses.count == 0 {
                    self?.onProfileFetched?(true)
                } else {
                    self?.onProfileFetched?(false)
                }
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func getCellModel(index: Int) -> HomeTableViewCellModel {
        let course = profile?.courses[index]

        let isOdd = index % 2 != 0

        return HomeTableViewCellModel(
            name: course?.courseName ?? "",
            supervisor: course?.supervisorName ?? "",
            background: isOdd ? UIColor.mySecondary : .white,
            titleColor: isOdd ? .white : UIColor.myAccent,
            subTitleColor: isOdd ? .myGray : .gray
        )
    }
}
