//
//  ProfileViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareemm on 06/01/2024.
//

import UIKit

class ProfileViewModel {

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
                SendBirdManager.shared.updateUserInfo()
                self?.onProfileFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func updateProfile(image: UIImage) {
        guard let regID = AuthManager.shared.regID else { return }
        let route = ProfileRouter.updateProfilePic(regID: regID)
        BaseClient.shared.uploadImage(image: image, router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.getProfile()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func removeProfileImage() {
        guard let regID = AuthManager.shared.regID else { return }
        let route = ProfileRouter.deleteProfilePic(regID: regID)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.getProfile()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
