//
//  ItemDetailsViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 13/01/2024.
//

import UIKit.UIImage

enum ItemDetailsSectionTypes {
    case image
    case itemInfo
    case contactInfo
    
    var sectionTitle: String? {
        switch self {
        case .image:
            return nil
        case .itemInfo:
            return "Item Info"
        case .contactInfo:
            return "Contact Info"
        }
    }
}

class ItemDetailsViewModel {
    var item: StoreItem

    var sections: [ItemDetailsSectionTypes] {
        return [.image, .itemInfo, .contactInfo]
    }
    
    var itemImageURLString: String {
        return AppManager.shared.item?.image ?? ""
    }

    var isMyItem: Bool {
        return (AppManager.shared.item?.regID == AuthManager.shared.regID)
    }

    var itemInfoCells: [ItemDetailsTableViewCellModel] {
        return [
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.price.image,
                title: AppManager.shared.item?.price ?? ""
            ),
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.location.image,
                title: AppManager.shared.item?.location ?? ""
            ),
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.number.image,
                title: AppManager.shared.item?.quantity ?? ""
            )
        ]
    }

    var contactInfoCells: [ItemDetailsTableViewCellModel] {
        var cellModels = [
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.name.image,
                title: AppManager.shared.item?.name ?? ""
            ),
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.email.image,
                title: AppManager.shared.item?.email ?? "",
                showCopyButton: true
            )]
        if item.showPhoneNumber {
            cellModels.append(
                ItemDetailsTableViewCellModel(
                    image: UIImage.SystemImages.phone.image,
                    title: AppManager.shared.item?.phoneNumber ?? ""
                )
            )
        }
        return cellModels
    }

    var onShowError: ((_ msg: String) -> Void)?

    var onItemDeleted: (() -> Void)?

    init(item: StoreItem) {
        if let storeItem = AppManager.shared.item {
            self.item = storeItem
        } else {
            self.item = item
        }
//
//        itemInfoCells = [
//            ItemDetailsTableViewCellModel(
//                image: UIImage.SystemImages.price.image,
//                title: item.price
//            ),
//            ItemDetailsTableViewCellModel(
//                image: UIImage.SystemImages.location.image,
//                title: item.location
//            ),
//            ItemDetailsTableViewCellModel(
//                image: UIImage.SystemImages.number.image,
//                title: item.quantity
//            )
//        ]
//
//        contactInfoCells = [
//            ItemDetailsTableViewCellModel(
//                image: UIImage.SystemImages.name.image,
//                title: item.name
//            ),
//            ItemDetailsTableViewCellModel(
//                image: UIImage.SystemImages.email.image,
//                title: item.email,
//                showCopyButton: true
//            ),
//            ItemDetailsTableViewCellModel(
//                image: UIImage.SystemImages.phone.image,
//                title: item.phoneNumber
//            )
//        ]
    }

    func getFooterButtonTitle() -> String? {
        if isMyItem {
            return "DELETE"
        } else {
            return nil
        }
    }

    func deleteItem() {
        let route = StoreRouter.deleteItem(id: item.id)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.onItemDeleted?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
