//
//  PeerMatchingViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/01/2024.
//

import Foundation

enum PeerMatchingSectionTypes: Int, CaseIterable {
    case mySkills
    case peerSkills

    func getTitle() -> String {
        switch self {
        case .mySkills:
            return "My Skills"
        case .peerSkills:
            return "Peer Skills"
        }
    }

    var isEditButtonHidden: Bool {
        switch self {
        case .mySkills:
            return false
        case .peerSkills:
            return true
        }
    }
}

class PeerMatchingViewModel {
    let sections = PeerMatchingSectionTypes.allCases

    var onShowError: ((_ msg: String) -> Void)?
    var onCategoriesFetched: (() -> Void)?
    var onPeerMatched: (() -> Void)?

    var customSkillsSelected = false
    var customSkills: String?
    var matchedStudents: [Peer] = []

    let peerSkillsTitles = [
        "Skill Mirror",
        "Skill Contrast",
        "Custom Skill Finder"
    ]

    let peerSkillsDescriptions = [
        "Find peers with skills similar to yours",
        "Connect with peers who have skills that complement yours.",
        "Specify and search for peers with custom skill sets."
    ]

    var selectedIndex = -1

    func getCategories() {
        guard let courseID = AppManager.shared.course?.courseID else { return }
        let route = RegisterRouter.getCategories(courseID: courseID)
        BaseClient.shared.performRequest(router: route, type: [Category].self) { [weak self] result in
            switch result {
            case .success(let categories):
                AppManager.shared.categories = categories
                self?.onCategoriesFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func matchWithPeer() {
        guard let courseID = AppManager.shared.course?.courseID,
              let regID = AuthManager.shared.regID else { return }
        var route: PeerRouter
        if customSkillsSelected {
            guard let customSkills = customSkills else { return }
            route = PeerRouter.matchWithCustommSkills(regID: regID, courseID: courseID, studentVector: customSkills)
        } else if (selectedIndex == 0) {
            route = PeerRouter.matchWithSameSkills(regID: regID, courseID: courseID)
        } else {
            route = PeerRouter.matchWithOppositeSkills(regID: regID, courseID: courseID)
        }
        BaseClient.shared.performRequest(router: route, type: [Peer].self) { [weak self] result in
            switch result {
            case .success(let students):
                self?.matchedStudents = students
                self?.onPeerMatched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func getCellModel(index: Int) -> PeerSkillsTableViewCellModel {
        var iconType: PeerCellIconType
        if (index == peerSkillsTitles.count - 1 && customSkillsSelected) {
            iconType = .selected
        } else if (index == peerSkillsTitles.count - 1) {
            iconType = PeerCellIconType.viewMore
        } else if (selectedIndex == index){
            iconType = .selected
        } else {
            iconType = .notSelected
        }
        return PeerSkillsTableViewCellModel(
            title: peerSkillsTitles[index],
            description: peerSkillsDescriptions[index],
            iconType: iconType
        )
    }
}
