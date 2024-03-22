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

protocol HomeViewModelProtocol {
    var onShowError: ((_ msg: String) -> Void)? { get set }
    var onProfileFetched: ((_ noCourses: Bool) -> Void)? { get set }

    var sections: [HomeSections] { get set }

    func getCellModel(index: Int) -> HomeTableViewCellModel
    func getProfile()
    func getCount() -> Int
    func getName() -> String
    func onCourseTapped(index: Int)
    func getCoursesCellsModel() -> [CourseCollectionViewCellModel]
}

class StudentHomeViewModel: HomeViewModelProtocol {

    var onShowError: ((_ msg: String) -> Void)?
    var onProfileFetched: ((_ noCourses: Bool) -> Void)?

    var sections: [HomeSections] = HomeSections.allCases

    var profile: StudentProfile?

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
                FiredatabaseManager.shared.signInAnonymously()
                FiredatabaseManager.shared.listenForIncomingRequests()
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
            title: course?.courseName ?? "",
            subtitle: course?.supervisorName ?? "",
            background: isOdd ? UIColor.mySecondary : .white,
            titleColor: isOdd ? .white : UIColor.myAccent,
            subTitleColor: isOdd ? .myGray : .gray
        )
    }

    func getCount() -> Int {
        return profile?.courses.count ?? 0
    }

    func getName() -> String {
        return profile?.name ?? ""
    }

    func onCourseTapped(index: Int) {
        AppManager.shared.course = profile?.courses[index]
    }

    func getCoursesCellsModel() -> [CourseCollectionViewCellModel] {
        let baseCells = [
            CourseCollectionViewCellModel(
                title: String.LocalizedKeys.boardTitle.localized,
                icon: UIImage.SystemImages.board.image
            ),
            CourseCollectionViewCellModel(
                title: String.LocalizedKeys.assignmentsTitle.localized,
                icon: UIImage.SystemImages.submission.image
            )
        ]

        let optionalCells = [
            CourseCollectionViewCellModel(
                title: String.LocalizedKeys.requestsTitle.localized,
                icon: UIImage.SystemImages.requests.image
            ),
            CourseCollectionViewCellModel(
                title: String.LocalizedKeys.choosePeerTitle.localized,
                icon: UIImage.SystemImages.choosePeer.image
            )
        ]

        let peerRegistrationNotFinished = !(AppManager.shared.profile?.peerRegistrationFinished ?? false)
        let cells = baseCells + (peerRegistrationNotFinished ? optionalCells : [])

        return cells
    }
}

class SupervisorHomeViewModel: HomeViewModelProtocol {

    var onShowError: ((_ msg: String) -> Void)?
    var onProfileFetched: ((_ noCourses: Bool) -> Void)?

    var sections: [HomeSections] = HomeSections.allCases

    var profile: SupervisorProfile?

    func getProfile() {
        guard let regID = AuthManager.shared.regID,
              let role = AuthManager.shared.role else { return }
        let route = HomeRouter.getProfile(regID: regID, role: role)
        BaseClient.shared.performRequest(router: route, type: SupervisorProfile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                AppManager.shared.supervisorProfile = profile
                SendBirdManager.shared.connectUser()
                FiredatabaseManager.shared.signInAnonymously()
                FiredatabaseManager.shared.listenForIncomingRequests()
                if profile.courseStudents?.count == 0 {
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
        let course = profile?.courseStudents?[index]

        let isOdd = index % 2 != 0

        return HomeTableViewCellModel(
            title: course?.courseName ?? "",
            subtitle: course?.courseID ?? "",
            background: isOdd ? UIColor.mySecondary : .white,
            titleColor: isOdd ? .white : UIColor.myAccent,
            subTitleColor: isOdd ? .myGray : .gray
        )
    }

    func getCount() -> Int {
        return profile?.courseStudents?.count ?? 0
    }

    func getName() -> String {
        return profile?.name ?? ""
    }

    func onCourseTapped(index: Int) {
        AppManager.shared.courseStudents = profile?.courseStudents?[index]
    }

    func getCoursesCellsModel() -> [CourseCollectionViewCellModel] {
        var cells = [
            CourseCollectionViewCellModel(
                title: String.LocalizedKeys.boardTitle.localized,
                icon: UIImage.SystemImages.board.image
            ),
            CourseCollectionViewCellModel(
                title: String.LocalizedKeys.assignmentsTitle.localized,
                icon: UIImage.SystemImages.submission.image
            ),
            CourseCollectionViewCellModel(
                title: String.LocalizedKeys.requestsTitle.localized,
                icon: UIImage.SystemImages.requests.image
            )
        ]

   //     if AppManager.shared.supervisorProfile?.peerRegistrationFinished ?? false {
            cells.remove(at: 2)
    //    }
        return cells
    }
}

//class HomeeViewModel {
//
//    // MARK: - Call Backs
//
//    var onShowError: ((_ msg: String) -> Void)?
//    var onProfileFetched: ((_ noCourses: Bool) -> Void)?
//
//    var profile: StudentProfile?
//    var supervisorProfile: SupervisorProfile?
//
//    let sections: [HomeSections] = HomeSections.allCases
//    let courseCollectionViewCell = [
//        CourseCollectionViewCellModel(
//            title: String.LocalizedKeys.choosePeerTitle.localized,
//            icon: UIImage.SystemImages.choosePeer.image
//        ),
//        CourseCollectionViewCellModel(
//            title: String.LocalizedKeys.boardTitle.localized,
//            icon: UIImage.SystemImages.board.image
//        ),
//        CourseCollectionViewCellModel(
//            title: String.LocalizedKeys.assignmentsTitle.localized,
//            icon: UIImage.SystemImages.submission.image
//        ),
//        CourseCollectionViewCellModel(
//            title: String.LocalizedKeys.requestsTitle.localized,
//            icon: UIImage.SystemImages.requests.image
//        )
//    ]
//
//    let role = Role.getRole()
//
//    var name: String {
//        switch role {
//        case .student:
//            return profile?.name ?? ""
//        case .supervisor:
//            return supervisorProfile?.name ?? ""
//        case .none:
//            return ""
//        }
//    }
//
//    // MARK: - Methods
//
//    func getProfile() {
//        switch role {
//        case .student:
//            getStudentProfile()
//        case .supervisor:
//            getSupervisorProfile()
//        case .none:
//            break
//        }
//    }
//
//    func getStudentProfile() {
//        guard let regID = AuthManager.shared.regID,
//              let role = AuthManager.shared.role else { return }
//        let route = HomeRouter.getProfile(regID: regID, role: role)
//        BaseClient.shared.performRequest(router: route, type: StudentProfile.self) { [weak self] result in
//            switch result {
//            case .success(let profile):
//                self?.profile = profile
//                AppManager.shared.profile = profile
//                SendBirdManager.shared.connectUser()
//                FiredatabaseManager.shared.signInAnonymously()
//                FiredatabaseManager.shared.listenForIncomingRequests()
//                if profile.courses.count == 0 {
//                    self?.onProfileFetched?(true)
//                } else {
//                    self?.onProfileFetched?(false)
//                }
//            case .failure(let error):
//                self?.onShowError?(error.localizedDescription)
//            }
//        }
//    }
//
//    func getSupervisorProfile() {
//        guard let regID = AuthManager.shared.regID,
//              let role = AuthManager.shared.role else { return }
//        let route = HomeRouter.getProfile(regID: regID, role: role)
//        BaseClient.shared.performRequest(router: route, type: SupervisorProfile.self) { [weak self] result in
//            switch result {
//            case .success(let profile):
//                self?.supervisorProfile = profile
//                AppManager.shared.supervisorProfile = profile
//                SendBirdManager.shared.connectUser()
//                FiredatabaseManager.shared.signInAnonymously()
//                FiredatabaseManager.shared.listenForIncomingRequests()
//                if profile.courseStudents?.count == 0 {
//                    self?.onProfileFetched?(true)
//                } else {
//                    self?.onProfileFetched?(false)
//                }
//            case .failure(let error):
//                self?.onShowError?(error.localizedDescription)
//            }
//        }
//    }
//
//    func courseTapped() {
//
//    }
//
//    func getCellModel(index: Int) -> HomeTableViewCellModel {
//        let course = profile?.courses[index]
//
//        let isOdd = index % 2 != 0
//
//        return HomeTableViewCellModel(
//            name: course?.courseName ?? "",
//            supervisor: course?.supervisorName ?? "",
//            background: isOdd ? UIColor.mySecondary : .white,
//            titleColor: isOdd ? .white : UIColor.myAccent,
//            subTitleColor: isOdd ? .myGray : .gray
//        )
//    }
//}
//
