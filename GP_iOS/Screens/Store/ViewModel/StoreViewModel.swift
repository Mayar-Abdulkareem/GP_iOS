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

    var storeFilterModel = StoreFilterModel(page: 1, title: nil, regID: nil, sortByPrice: nil)
    var items = [StoreItem]()
    var item = Item(id: "")
    var isLastResult = false
    var isFetching = false

    var role = Role.getRole()

    var hideForSupervisor: Bool {
        switch role {
        case .student:
            return false
        case .supervisor:
            return true
        case .none:
            return false
        }
    }

    // MARK: - Call Backs

    /// If error happens
    var onShowError: ((_ msg: String) -> Void)?
    /// If the fetch Items completed successfully
    var onItemFetched: ((_ noItems: Bool) -> Void)?

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
                self?.totalItemsCount = items.totalCount
                if self?.items.count == 0 {
                    self?.onItemFetched?(true)
                } else {
                    self?.onItemFetched?(false)
                }
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
                self?.storeFilterModel.page = 1
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
                self?.storeFilterModel.page = 1
                self?.fetchItems()
                self?.item = Item(id: "")
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func getStoreCellModel(index: Int) -> StoreCollectionViewCellModel {
        return StoreCollectionViewCellModel(
            image: items[index].image,
            title: items[index].title,
            index: index
        )
    }
}
