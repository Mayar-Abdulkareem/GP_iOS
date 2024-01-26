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

    var image: String? {
        switch self {
        case .add:
            return nil
        case .edit:
            return AppManager.shared.item?.image
        }
    }
}

protocol StoreItemAddEditBaseCellModel {}

class StoreItemAddEditViewModel {

    lazy var cells: [StoreItemAddEditBaseCellModel] = [
        ItemDetailsImageCellModel(imageString: viewType.image, isEditable: true),
        ItemAddEditTextCellModel(fieldTypes: .name, value: item.title ?? ""),
        ItemAddEditTextCellModel(fieldTypes: .price, value: item.price ?? ""),
        ItemAddEditTextCellModel(fieldTypes: .location, value: item.location ?? ""),
        ItemAddEditQuantityCellModel(quantity: Double(AppManager.shared.item?.quantity ?? "1.0") ?? 1.0),
        ItemAddEditCheckBoxCellModel(isSelected: AppManager.shared.item?.showPhoneNumber ?? false)
    ]

    let viewType: StoreItemAddEditViewType
    var item: Item

    // MARK: - Computed Property

    var areItemFieldsFilled: Bool {
        if let quantity = item.quantity, !quantity.isEmpty,
           let location = item.location, !location.isEmpty,
           let price = item.price, !price.isEmpty,
           let title = item.title, !title.isEmpty,
           item.image != nil {
            return true
        } else {
            return false
        }
    }

    // MARK: - Call backs

    /// If error happens
    var onShowError: ((_ msg: String) -> Void)?
    /// If the fetch Items completed successfully
    var onItemAddedOrUpdated: (() -> Void)?

    init(viewType: StoreItemAddEditViewType,
         item: Item) {
        self.viewType = viewType
        self.item = item
    }

    func updateOrAddItem(route: StoreRouter) {
        BaseClient.shared.uploadImage(image: item.image, router: route, type: StoreItem.self) { [weak self] result in
            switch result {
            case .success(let item):
                AppManager.shared.item = item
                self?.onItemAddedOrUpdated?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func addItem() {
        guard let regID = AuthManager.shared.regID else { return }
        if !areItemFieldsFilled {
            onShowError?(String.LocalizedKeys.fillAllFields.localized)
            return
        }
        if  let price = item.price,
            let _ = Float(price) {
        } else {
            onShowError?(String.LocalizedKeys.priceDataTypeError.localized)
            return
        }
        item.id = regID
        let route = StoreRouter.addItem(item: item)
        BaseClient.shared.uploadImage(image: item.image, router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.onItemAddedOrUpdated?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func editItem() {
        guard let id = AppManager.shared.item?.id else { return }
        if !areItemFieldsFilled {
            onShowError?(String.LocalizedKeys.fillAllFields.localized)
            return
        }
        if  let price = item.price,
            let _ = Float(price) {
        } else {
            onShowError?(String.LocalizedKeys.priceDataTypeError.localized)
            return
        }
        item.id = id
        let route = StoreRouter.updateItem(item: item)
        BaseClient.shared.uploadImage(image: item.image, router: route, type: StoreItem.self) { [weak self] result in
            switch result {
            case .success(let item):
                AppManager.shared.item = item
                self?.onItemAddedOrUpdated?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }

    }
}
