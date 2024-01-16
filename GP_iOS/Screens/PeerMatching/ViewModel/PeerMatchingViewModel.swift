//
//  PeerMatchingViewModel.swift
//  GP_iOS
//
//  Created by FTS on 15/01/2024.
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

    var onCategoriesFetched: (() -> Void)?
    var onShowError: ((_ msg: String) -> Void)?

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

    func getCellModel(index: Int) -> PeerSkillsTableViewCellModel {
        var iconType: PeerCellIconType
        if (index == peerSkillsTitles.count - 1) {
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
