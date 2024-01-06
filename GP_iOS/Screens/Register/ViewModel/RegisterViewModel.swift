//
//  RegisterViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 01/01/2024.
//

import UIKit

enum RequestStatus: Equatable {
    case notSent
    case pending
    case accepted(supervisorName: String)

    var requestButtonText: String {
        switch self {
        case .notSent:
            return String.LocalizedKeys.sendRequestButtonTitle.localized
        default:
            return String.LocalizedKeys.cancelRequestButtonTitle.localized
        }
    }

    var requestLabelText: String {
        switch self {
        case .pending:
            return String.LocalizedKeys.requestSentText.localized
        case .accepted(let name):
            return String.LocalizedKeys.requestApprovedText.localized + " " + name
        default:
            return String.LocalizedKeys.cancelRequestButtonTitle.localized
        }
    }

    func getRegisterCourseStatusLabelText(step: Int) -> String {
        switch self {
        case .pending:
            return String.LocalizedKeys.registerCoursePendingText.localized
        case .accepted:
            return String.LocalizedKeys.noMoreCoursesToRegister.localized
        default:
            return ""
        }
    }
}

class RegisterViewModel {
    var currentStep = 1
    var selectedIndexPath: IndexPath?
    // Step 1
    var availableCourses = [AvailableCourse]()
    var selectedCourse: AvailableCourse?
    // Step 2
    var availableSupervisors = [AvailableSupervisor]()
    var requestStatus: RequestStatus = .notSent
    var selectedSupervisor: AvailableSupervisor?
    // Step 3
    var categoriesWithSkills: [Category] = []


    var onShowError: ((_ msg: String) -> Void)?
    var onRequestFetched: (() -> Void)?
    var onCourseRegistered: (() -> Void)?
    // Step 1
    var onAvailableCoursesFetched: ((_ noAvailableCourses: Bool) -> Void)?
    // Step 2
    var onAvailableSupervisorsFetched: ((_ noAvailableSupervisors: Bool) -> Void)?
    var onRequestSent: (() -> Void)?
    var onRequestDeleted: (() -> Void)?
    var request: Request?
    // Step 3
    var onCategoriesFetched: ((_ noCategories: Bool) -> Void)?

    func fetchAvailableCourses() {
        guard let id = AuthManager.shared.regID else { return }
        let route = RegisterRouter.getAvailableCourses(regID: id)
        BaseClient.shared.performRequest(router: route, type: [AvailableCourse].self) { [weak self] result in
            switch result {
            case .success(let courses):
                self?.availableCourses = courses
                if self?.availableCourses.count == 0 {
                    self?.onAvailableCoursesFetched?(true)
                } else {
                    self?.onAvailableCoursesFetched?(false)
                }
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func fetchAvailableSupervisors() {
        guard let id = selectedCourse?.courseID else { return }
        let route = RegisterRouter.getAvailableSupervisors(courseID: id)
        BaseClient.shared.performRequest(router: route, type: [AvailableSupervisor].self) { [weak self] result in
            switch result {
            case .success(let supervisors):
                self?.availableSupervisors = supervisors
                if self?.availableSupervisors.count == 0 {
                    self?.onAvailableSupervisorsFetched?(true)
                } else {
                    self?.onAvailableSupervisorsFetched?(false)
                }
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func postRequest() {
        guard let courseID = selectedCourse?.courseID,
              let studentID = AuthManager.shared.regID,
              let supervisorID = selectedSupervisor?.regID
        else { return }
        let route = RegisterRouter.postRequestForSupervisor(request: Request(senderID: studentID, receiverID: supervisorID, courseID: courseID, status: "", type: "", senderName: "", receiverName: ""))
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.requestStatus = .pending
                self?.onRequestSent?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func deleteRequest() {
        guard let studentID = AuthManager.shared.regID
        else { return }

        let route = RegisterRouter.deleteRequestFirSupervisor(studentID: studentID)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.requestStatus = .notSent
                self?.fetchAvailableSupervisors()
                //self?.onRequestDeleted?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func setStep() {
        guard let studentID = AuthManager.shared.regID else { return }
        let route = RegisterRouter.getRequest(studentID: studentID)
        BaseClient.shared.performRequest(router: route, type: Request.self) { [weak self] result in
            switch result {
            case .success(let studentRequet):
                switch studentRequet.type {
                case "supervisor":
                    self?.currentStep = 2
                    if studentRequet.status == "pending"{
                        self?.requestStatus = .pending
                    } else {
                        self?.requestStatus = .accepted(supervisorName: studentRequet.receiverName)
                    }
                case "course":
                    self?.currentStep = 4
                    if studentRequet.status == "pending"{
                        self?.requestStatus = .pending
                    } else {
                        self?.requestStatus = .accepted(supervisorName: studentRequet.receiverName)
                    }
                default:
                    self?.currentStep = 1
                }
                self?.request = studentRequet
                self?.onRequestFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func getCategories() {
        guard let courseID = AppManager.shared.course?.courseID ?? request?.courseID else { return }
        let route = RegisterRouter.getCategories(courseID: courseID)
        BaseClient.shared.performRequest(router: route, type: [Category].self) { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categoriesWithSkills = categories
                if categories.count == 0 {
                    self?.onCategoriesFetched?(true)
                } else {
                    self?.onCategoriesFetched?(false)
                }
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func registerCourse() {
        guard let courseID = AppManager.shared.course?.courseID ?? request?.courseID,
              let studentID = AuthManager.shared.regID else { return }
        let skillsVector = MatchingPeerManager.shared.createVector(from: categoriesWithSkills)
        let route = RegisterRouter.registerCourse(studentID: studentID, courseID: courseID, skillsVector: skillsVector)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.requestStatus = .pending
                self?.onCourseRegistered?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
