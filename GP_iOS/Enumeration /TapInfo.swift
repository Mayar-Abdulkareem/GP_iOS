//
//  TapInfo.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 12/12/2023.
//

import UIKit

enum TabInfo {
    case home
    case search
    case store
    case more

    var localizedTitle: String {
        switch self {
        case .home: return String.LocalizedKeys.homeTitle.localized
        case .search: return String.LocalizedKeys.previousProjectTitle.localized
        case .store: return String.LocalizedKeys.storeTitle.localized
        case .more: return String.LocalizedKeys.moreTitle.localized
        }
    }

    var systemImage: UIImage {
        switch self {
        case .home: return UIImage.SystemImages.home.image
        case .search: return UIImage.SystemImages.search.image
        case .store: return UIImage.SystemImages.store.image
        case .more: return UIImage.SystemImages.more.image
        }
    }

    var tag: Int {
        switch self {
        case .home: return 0
        case .search: return 1
        case .store: return 2
        case .more: return 3
        }
    }

    func createTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: localizedTitle,
            image: systemImage,
            tag: tag
        )
    }
}
