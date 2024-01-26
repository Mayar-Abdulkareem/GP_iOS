//
//  AdminTableViewModel.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import Foundation

protocol AdminTableViewModelProtocol: AnyObject {

    var onDataFetched: (() -> Void)? { set get }
    var onShowError: ((_ msg: String) -> Void)? { set get }

    var cells: [AdminTableCellModel] { get }

    func getData()
    func getNavTitle() -> String
    func getFooterButtonTitle() -> String?
    func search(text: String)

    func primaryButtonTapped()
    func secondaryButtonTapped()
}

extension AdminTableViewModelProtocol {
    func primaryButtonTapped() {}
    func secondaryButtonTapped() {}
    func getFooterButtonTitle() -> String? {
        return nil
    }
}
