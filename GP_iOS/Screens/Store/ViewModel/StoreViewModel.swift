//
//  StoreViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 24/12/2023.
//

import Alamofire

class StoreViewModel {
    
    // MARK: - Variables
    
    private(set) var totalItemsCount = 0
    
    var viewType = ViewType.itemDetails
    var page = Page.itemInfo
    var state = State.normal
    
    var storeFilterModel = StoreFilterModel(page: 1, title: nil, regID: nil, sortByPrice: nil)
    var items = [StoreItem]()
    var item = Item(id: "")
    var isLastResult = false
    
    // MARK: - Call Backs
    
    /// If error happens
    var onShowError: ((_ msg: String) -> Void)?
    /// If the fetch Items completed successfully
    var onItemFetched: ((_ noItems: Bool) -> ())?
        
    // MARK: - Computed Property
    
    var areItemFieldsFilled: Bool {
        if let quantity = item.quantity, !quantity.isEmpty,
           let location = item.location, !location.isEmpty,
           let _ = item.image,
           let price = item.price, !price.isEmpty,
           let title = item.title, !title.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Methods
    
    /// Fetch Items
    func fetchItems() {
        let route = StoreRouter.getAllItems(storeFilterModel: storeFilterModel)
        BaseClient.shared.performRequest(router: route, type: StoreResponse.self) { [weak self] result in
            switch result {
            case .success(let items):
                if self?.storeFilterModel.page == 1 {
                    self?.items = items.storeItems
                } else {
                    self?.items += items.storeItems
                }
                if items.storeItems.count == 0 {
                    self?.onItemFetched?(true)
                } else {
                    self?.onItemFetched?(false)
                }
                self?.totalItemsCount = items.totalCount
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
    
    func deleteItem(id: String) {
        let route = StoreRouter.deleteItem(id: id)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.fetchItems()
                self?.item = Item(id: "")
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
    
    func updateOrAddItem(route: StoreRouter) {
            BaseClient.shared.uploadImage(image: item.image, router: route, type: String.self) { [weak self] result in
                switch result {
                case .success:
                    self?.fetchItems()
                    self?.item = Item(id: "")
                case .failure(let error):
                    self?.onShowError?(error.localizedDescription)
                }
            }
    }
    
    func getStoreCellModel(index: Int) -> StoreCollectionViewCellModel {
        return StoreCollectionViewCellModel(
            image: items[index].uiImage,
            title: items[index].title
        )
    }
}
