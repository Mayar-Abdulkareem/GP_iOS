//
//  PeerViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 14/01/2024.
//

import UIKit

enum PeerSections: Int, CaseIterable {
    case header
    case options

    func getTitle() -> String? {
        switch self {
        case .header:
            return nil
        case .options:
            return "Options"
        }
    }
}

enum PeerViewType {
    case sendRequset
    case pending
    case accepted
}

class PeerViewModel {

    let options = ["Have a Peer in Mind", "Match Me with a Peer"]
    let sections: [PeerSections] = PeerSections.allCases

    var request: Request?
    var viewType = PeerViewType.sendRequset

    // MARK: - Call Backs

    var onShowError: ((_ msg: String) -> Void)?
    var onRequestSent: (() -> Void)?
    var onRequestFetched: (() -> Void)?
    var onRequestCanceled: (() -> Void)?


    // MARK: - Methods

    func getCellModel(index: Int) -> PeerTableViewCellModel {

        let isOdd = index % 2 != 0

        return PeerTableViewCellModel(
            title: options[index],
            background: isOdd ? UIColor.mySecondary : .white,
            titleColor: isOdd ? .myPrimary : .myAccent
        )
    }

    func sendPeerRequest(peerID: String) {
        guard let regID = AuthManager.shared.regID else { return }
        let route = PeerRouter.sendPeerRequest(regID: regID, peerID: peerID)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success(let message):
                if message == "Successfully sent the peer request." {
                    self?.viewType = .pending
                    self?.onRequestSent?()
                } else {
                    self?.onShowError?(message)
                }
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func cancelPeerRequest() {
        guard let regID = AuthManager.shared.regID else { return }
        let route = PeerRouter.cancelPeerRequest(regID: regID)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success(let message):
                self?.viewType = .sendRequset
                self?.onRequestCanceled?()
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

                if studentRequet.status == "pending" && studentRequet.type == "peer" {
                    self?.viewType = .pending
                } else if studentRequet.status == "accepted" && studentRequet.type == "peer" {
                    self?.viewType = .accepted
                } else {
                    self?.viewType = .sendRequset
                }

                self?.request = studentRequet
                self?.onRequestFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
