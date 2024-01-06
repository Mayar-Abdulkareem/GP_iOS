//
//  AnnouncementViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 06/01/2024.
//

import Foundation

class AnnouncementViewModel {

    // MARK: - Call Backs

    var onShowError: ((_ msg: String) -> Void)?
    var onProfileFetched: (() -> Void)?

    var profile: StudentProfile?

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
                self?.onProfileFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}

