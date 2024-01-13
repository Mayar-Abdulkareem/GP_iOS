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
    let item: StoreItem
    
    var sections: [ItemDetailsSectionTypes] {
        return [.image, .itemInfo, .contactInfo]
    }
    
    var itemImageURLString: String {
        return item.image
    }
    
    let itemInfoCells: [ItemDetailsTableViewCellModel]
    let contactInfoCells: [ItemDetailsTableViewCellModel]
    
    init(item: StoreItem) {
        self.item = item
        
        itemInfoCells = [
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.price.image,
                title: item.price
            ),
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.location.image,
                title: item.location
            ),
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.number.image,
                title: item.quantity
            )
        ]
        
        contactInfoCells = [
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.name.image,
                title: item.name
            ),
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.email.image,
                title: item.email,
                showCopyButton: true
            ), 
            ItemDetailsTableViewCellModel(
                image: UIImage.SystemImages.phone.image,
                title: item.phoneNumber
            )
        ]
    }
}
