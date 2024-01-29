////
////  StoreViewType.swift
////  GP_iOS
////
////  Created by Mayar Abdulkareem on 26/12/2023.
////
//
//import UIKit
//
//enum ViewType {
//    // When the user select any item
//    case itemDetails
//    // When the user click on + button
//    case addItem
//
//    /// Title for the page
//    var title: String {
//        switch self {
//        case .itemDetails:
//            return String.LocalizedKeys.itemDetailsTitle.localized
//        case .addItem:
//            return String.LocalizedKeys.addItemTitle.localized
//        }
//    }
//
//    /// Change or add photo
//    var photoButtonTitle: String {
//        switch self {
//        case .itemDetails:
//            return String.LocalizedKeys.changePhotoTitle.localized
//        case .addItem:
//            return String.LocalizedKeys.addPhotoTitle.localized
//        }
//    }
//
//
//
//    /// Selected item title or nil
//    var itemTitleTextFieldText: String? {
//        switch self {
//        case .itemDetails:
//            return AppManager.shared.item?.title
//        case .addItem:
//            return nil
//        }
//    }
//
//    /// Item title placeholder or nil
//    var itemTitleTextFieldPlaceHolder: String? {
//        switch self {
//        case .itemDetails:
//            return nil
//        case .addItem:
//            return String.LocalizedKeys.enterItemName.localized
//        }
//    }
//
//    /// Selected item price or nil
//    var priceTitleTextFieldText: String? {
//        switch self {
//        case .itemDetails:
//            return AppManager.shared.item?.price
//        case .addItem:
//            return nil
//        }
//    }
//
//    /// Item price placeholder or nil
//    var priceTitleTextFieldPlaceHolder: String? {
//        switch self {
//        case .itemDetails:
//            return nil
//        case .addItem:
//            return String.LocalizedKeys.enterItemPrice.localized
//        }
//    }
//
//    /// Selected item location or nil
//    var locationTitleTextFieldText: String? {
//        switch self {
//        case .itemDetails:
//            return AppManager.shared.item?.location
//        case .addItem:
//            return nil
//        }
//    }
//
//    /// Item location placeholder
//    var locationTitleTextFieldPlaceHolder: String? {
//        switch self {
//        case .itemDetails:
//            return nil
//        case .addItem:
//            return String.LocalizedKeys.enterItemLocation.localized
//        }
//    }
//
//    /// Selected item quantity or default 1
//    var quantityTitleTextFieldText: String? {
//        switch self {
//        case .itemDetails:
//            return AppManager.shared.item?.quantity
//        case .addItem:
//            return "1"
//        }
//    }
//
//    /// Show item title borders when editable or not
//    var itemTitleTextFieldBorderStyle: UITextField.BorderStyle {
//        switch self {
//        case .itemDetails:
//            return .none
//        case .addItem:
//            return .roundedRect
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
//}
//
//enum Page {
//    // Default for both view type
//    case itemInfo
//    // When switching to contact using the segment control
//    case contactInfo
//}
//
//enum State {
//    // Read item info only
//    case normal
//    // Edit item info
//    case edit
//}
