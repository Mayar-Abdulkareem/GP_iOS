//
//  StoreItemAddEditViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 23/01/2024.
//

enum StoreItemAddEditViewType {
    case add
    case edit
    
    var title: String {
        switch self {
        case .add: 
            return String.LocalizedKeys.addItemTitle.localized
        case .edit:
            return "Edit Item"
        }
    }
    
    var bottomButtonTitle: String {
        switch self {
        case .add:
            return "Add"
        case .edit:
            return "Save"
        }
    }
}

protocol StoreItemAddEditBaseCellModel {}

class StoreItemAddEditViewModel {
    
    lazy var cells: [StoreItemAddEditBaseCellModel] = [
        ItemDetailsImageCellModel(imageString: nil, isEditable: true),
        ItemAddEditTextCellModel(fieldTypes: .name, value: item.title ?? ""),
        ItemAddEditTextCellModel(fieldTypes: .price, value: item.price ?? ""),
        ItemAddEditTextCellModel(fieldTypes: .location, value: item.location ?? ""),
        ItemAddEditQuantityCellModel(quantity: Double(AppManager.shared.item?.quantity ?? "1.0") ?? 1.0),
        ItemAddEditCheckBoxCellModel(isSelected: AppManager.shared.item?.showPhoneNumber ?? false)
    ]
    
    let viewType: StoreItemAddEditViewType
    var item: Item
    
    init(viewType: StoreItemAddEditViewType,
         item: Item) {
        self.viewType = viewType
        self.item = item
    }
}
