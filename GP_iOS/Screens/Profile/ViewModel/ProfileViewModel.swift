//
//  ProfileViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareemm on 06/01/2024.
//

import UIKit

class ProfileViewModelProtocol {
    var onShowError: ((_ msg: String) -> Void)?
    var onProfileFetched: (() -> Void)?

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

    var cellsModel: [LabelIconCellModel] {
        return []
    }

    var image: String? {
        return ""
    }

    func getProfile() {
        return
    }
    func getCount() -> Int {
        return 0
    }
    func getName() -> String {
        return ""
    }
}

class StudentProfileViewModel: ProfileViewModelProtocol {

    var profile: StudentProfile?

    override var cellsModel: [LabelIconCellModel] { return [
        LabelIconCellModel(
            icon: UIImage.SystemImages.regID.image,
            prefixText:String.LocalizedKeys.regID.localized,
            valueText: AppManager.shared.profile?.regID ?? ""
        ),
        LabelIconCellModel(
            icon:  UIImage.SystemImages.email.image,
            prefixText: String.LocalizedKeys.email.localized,
            valueText: AppManager.shared.profile?.email ?? ""
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.phone.image,
            prefixText: String.LocalizedKeys.phoneNumber.localized,
            valueText: AppManager.shared.profile?.phoneNumber ?? ""
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.GPA.image,
            prefixText: String.LocalizedKeys.gpa.localized,
            valueText: AppManager.shared.profile?.GPA ?? "",
            isLastCell: true
        )] }

    override var image: String? {
        return AppManager.shared.profile?.profileImage
    }

    override func getProfile() {
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

    override func getCount() -> Int {
        return profile?.courses.count ?? 0
    }

    override func getName() -> String {
        return profile?.name ?? ""
    }
}

class SupervisorProfileViewModel: ProfileViewModelProtocol {

    var profile: SupervisorProfile?

    override var cellsModel: [LabelIconCellModel] { return [
        LabelIconCellModel(
            icon: UIImage.SystemImages.regID.image,
            prefixText:String.LocalizedKeys.regID.localized,
            valueText: AppManager.shared.supervisorProfile?.regID ?? ""
        ),
        LabelIconCellModel(
            icon:  UIImage.SystemImages.email.image,
            prefixText: String.LocalizedKeys.email.localized,
            valueText: AppManager.shared.supervisorProfile?.email ?? "",
            isLastCell: true
        )
    ]}

    override var image: String? {
        return AppManager.shared.supervisorProfile?.profileImage
    }

    override func getProfile() {
        guard let regID = AuthManager.shared.regID,
              let role = AuthManager.shared.role else { return }
        let route = HomeRouter.getProfile(regID: regID, role: role)
        BaseClient.shared.performRequest(router: route, type: SupervisorProfile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                AppManager.shared.supervisorProfile = profile
                self?.onProfileFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    override func getCount() -> Int {
        return profile?.courseStudents?.count ?? 0
    }

    override func getName() -> String {
        return profile?.name ?? ""
    }
}
