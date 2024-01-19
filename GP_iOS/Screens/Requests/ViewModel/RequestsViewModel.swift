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

class RequestsViewModel {

    var requests: [Request]?
    var viewType = RequestViewType.canAcceptRequests

    // MARK: - Call Backs

    var onShowError: ((_ msg: String) -> Void)?
    var onRequestsFetched: (() -> Void)?
    var onRequestAccepted: (() -> Void)?
    var onRequestDeclined: (() -> Void)?
    var onViewTypeSpecified: (() -> Void)?


    // MARK: - Methods

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

    func acceptPeerRequest(peerID: String) {
        guard let regID = AuthManager.shared.regID else { return }
        let route = RequestRouter.acceptPeerRequest(regID: regID, peerID: peerID)
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

    func declinePeerRequest(peerID: String) {
        let route = RequestRouter.declinePeerRequest(peerID: peerID)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success(let message):
                self?.viewType = .canAcceptRequests
                self?.onRequestDeclined?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func setViewType() {
        guard let studentID = AuthManager.shared.regID else { return }
        let route = RegisterRouter.getRequest(studentID: studentID)
        BaseClient.shared.performRequest(router: route, type: Request.self) { [weak self] result in
            switch result {
            case .success(let studentRequet):
                if studentRequet.status == "accepted" && studentRequet.type == "peer" {
                    self?.viewType = .requestAccepted
                    self?.onViewTypeSpecified?()
                } else {
                    self?.viewType = .canAcceptRequests
                    self?.getMyRequests()
                }
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
