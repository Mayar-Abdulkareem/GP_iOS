//
//  TaskViewType.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareemm on 09/01/2024.
//

import UIKit

enum TaskViewType {
    // When the user clicks on any task
    case read
    // When the user clicks on edit button
    case edit
    // When the user clicks on add task
    case add

    /// Title for the page
//    var title: String {
//        switch self {
//        case .itemDetails:
//            return String.LocalizedKeys.itemDetailsTitle.localized
//        case .addItem:
//            return String.LocalizedKeys.addItemTitle.localized
//        }
//    }

//    /// Item title placeholder or nil
//    var taskTitleTextFieldPlaceHolder: String? {
//        switch self {
//        case .itemDetails:
//            return nil
//        case .addItem:
//            return String.LocalizedKeys.enterItemName.localized
//        }
//    }
//
//    /// Item location placeholder
//    var descriptionTextViewPlaceHolder: String? {
//        switch self {
//        case .itemDetails:
//            return nil
//        case .addItem:
//
//        }
//    }
//
//    /// Execute update or add on save tapped
//    func actionOnSaveClicked(viewModel: StoreViewModel) {
//        switch self {
//        case .itemDetails:
//            if let id = AppManager.shared.item?.id {
//                viewModel.item.id = id
//                let route = StoreRouter.updateItem(item: viewModel.item)
//                viewModel.updateOrAddItem(route: route)
//            }
//        case .addItem:
//            if let regID = AuthManager.shared.regID {
//                viewModel.item.id = regID
//                let route = StoreRouter.addItem(item: viewModel.item)
//                viewModel.updateOrAddItem(route: route)
//            }
//        }
//    }
}
