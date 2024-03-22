//
//  SkillsViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 20/01/2024.
//

import Foundation

enum SkillsViewType {
    case editStudentSkills
    case customSkillsForPeer
}

class SkillsViewModel {
    var categoriesWithSkills: [Category] = []

    var context: SkillsViewType = .editStudentSkills

    var onSkillsUpdated: (() -> Void)?
    var onShowError: ((_ msg: String) -> Void)?

    func updateSkillsVector(skillsVector: String) {
        guard let regID = AuthManager.shared.regID else { return }
        let route = RequestRouter.updateSkillsVector(regID: regID, skillsVector: skillsVector)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success(let msg):
                AppManager.shared.profile?.skillsVector = skillsVector
                self?.onSkillsUpdated?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
