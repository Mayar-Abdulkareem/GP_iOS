//
//  RequestViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 19/01/2024.
//

import UIKit

enum RequestViewType {
    case noRequests
    case requestAccepted
    case canAcceptRequests
}

protocol RequestViewModelProtocol {

    var onShowError: ((_ msg: String) -> Void)? { get set }
    var onRequestsFetched: (() -> Void)? { get set }
    var onRequestAccepted: (() -> Void)? { get set }
    var onRequestDeclined: (() -> Void)? { get set }
    var onViewTypeSpecified: (() -> Void)? { get set }

    var requests: [Request]? { get set }
    var viewType: RequestViewType { get set }

    func getMyRequests()
    func acceptRequest(id: String, name: String)
    func declineRequest(id: String)
}

class StudentRequestViewModel: RequestViewModelProtocol {
    var onShowError: ((String) -> Void)?
    var onRequestsFetched: (() -> Void)?
    var onRequestAccepted: (() -> Void)?
    var onRequestDeclined: (() -> Void)?
    
    var onViewTypeSpecified: (() -> Void)?

    var requests: [Request]?
    
    var viewType = RequestViewType.canAcceptRequests

    func getMyRequests() {
        guard let regID = AuthManager.shared.regID else { return }
        let route = RequestRouter.getPeerRequests(regID: regID)
        BaseClient.shared.performRequest(router: route, type: [Request].self) { [weak self] result in
            switch result {
            case .success(let requests):
                self?.requests = requests
                if (requests.count == 0) {
                    self?.viewType = .noRequests
                } else if (requests.count == 1 && requests[0].status == "accepted") {
                    self?.viewType = .requestAccepted
                } else {
                    self?.viewType = .canAcceptRequests
                }
                self?.onRequestsFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func acceptRequest(id: String, name: String) {
        guard let regID = AuthManager.shared.regID else { return }
        let route = RequestRouter.acceptPeerRequest(regID: regID, peerID: id)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success(let message):
                self?.viewType = .requestAccepted
                self?.onRequestAccepted?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func declineRequest(id: String) {
        let route = RequestRouter.declinePeerRequest(peerID: id)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success(let message):
                self?.getMyRequests()
                self?.viewType = .canAcceptRequests
                self?.onRequestDeclined?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}

class SupervisorRequestViewModel: RequestViewModelProtocol {
    
    var onShowError: ((String) -> Void)?
    var onRequestsFetched: (() -> Void)?
    var onRequestAccepted: (() -> Void)?
    var onRequestDeclined: (() -> Void)?
    
    var onViewTypeSpecified: (() -> Void)?

    var requests: [Request]?
    
    var viewType = RequestViewType.canAcceptRequests

    func getMyRequests() {
        guard let regID = AuthManager.shared.regID,
              let courseID = AppManager.shared.courseStudents?.courseID else { return }
        let route = RequestRouter.getSupervisorRequests(receiverID: regID, courseID: courseID)
        BaseClient.shared.performRequest(router: route, type: [Request].self) { [weak self] result in
            switch result {
            case .success(let requests):
                self?.requests = requests
                if (requests.count == 0) {
                    self?.viewType = .noRequests
                } else if requests.count == 12 && requests.allSatisfy({ $0.status == "accepted" }) {
                    self?.viewType = .requestAccepted
                } else {
                    self?.viewType = .canAcceptRequests
                }
                self?.onRequestsFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func acceptRequest(id: String, name: String) {
        guard let regID = AuthManager.shared.regID,
              let courseID = AppManager.shared.courseStudents?.courseID else { return }
        let route = RequestRouter.acceptSupervisorRequest(
            senderID: id,
            receiverID: regID,
            courseID: courseID
        )
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success(let message):
                self?.getMyRequests()
                AppManager.shared.courseStudents?.students?.append(StudentCourse(id: id, name: name))
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func declineRequest(id: String) {
        let route = RequestRouter.declineSupervisorRequest(studentID: id)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success(let message):
                self?.getMyRequests()
                self?.viewType = .canAcceptRequests
                self?.onRequestDeclined?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
//
//class RequestsViewModel {
//
//    var requests: [Request]?
//    var viewType = RequestViewType.canAcceptRequests
//
//    // MARK: - Call Backs
//
//    var onShowError: ((_ msg: String) -> Void)?
//    var onRequestsFetched: (() -> Void)?
//    var onRequestAccepted: (() -> Void)?
//    var onRequestDeclined: (() -> Void)?
//    var onViewTypeSpecified: (() -> Void)?
//
//
//    // MARK: - Methods
//
//    func getMyRequests() {
//        guard let regID = AuthManager.shared.regID else { return }
//        let route = RequestRouter.getPeerRequests(regID: regID)
//        BaseClient.shared.performRequest(router: route, type: [Request].self) { [weak self] result in
//            switch result {
//            case .success(let requests):
//                self?.requests = requests
//                if (requests.count == 0) {
//                    self?.viewType = .noRequests
//                } else if (requests.count == 1 && requests[0].status == "accepted") {
//                    self?.viewType = .requestAccepted
//                } else {
//                    self?.viewType = .canAcceptRequests
//                }
//                self?.onRequestsFetched?()
//            case .failure(let error):
//                self?.onShowError?(error.localizedDescription)
//            }
//        }
//    }
//
//    func acceptPeerRequest(peerID: String) {
//        guard let regID = AuthManager.shared.regID else { return }
//        let route = RequestRouter.acceptPeerRequest(regID: regID, peerID: peerID)
//        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
//            switch result {
//            case .success(let message):
//                self?.viewType = .requestAccepted
//                self?.onRequestAccepted?()
//            case .failure(let error):
//                self?.onShowError?(error.localizedDescription)
//            }
//        }
//    }
//
//    func declinePeerRequest(peerID: String) {
//        let route = RequestRouter.declinePeerRequest(peerID: peerID)
//        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
//            switch result {
//            case .success(let message):
//                self?.viewType = .canAcceptRequests
//                self?.onRequestDeclined?()
//            case .failure(let error):
//                self?.onShowError?(error.localizedDescription)
//            }
//        }
//    }
//
//    func setViewType() {
//        guard let studentID = AuthManager.shared.regID else { return }
//        let route = RegisterRouter.getRequest(studentID: studentID)
//        BaseClient.shared.performRequest(router: route, type: Request.self) { [weak self] result in
//            switch result {
//            case .success(let studentRequet):
//                if studentRequet.status == "accepted" && studentRequet.type == "peer" {
//                    self?.viewType = .requestAccepted
//                    self?.onViewTypeSpecified?()
//                } else {
//                    self?.viewType = .canAcceptRequests
//                    self?.getMyRequests()
//                }
//            case .failure(let error):
//                self?.onShowError?(error.localizedDescription)
//            }
//        }
//    }
//}
