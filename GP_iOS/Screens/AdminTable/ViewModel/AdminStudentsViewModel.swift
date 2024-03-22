//
//  AdminStudentsViewModel.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import Foundation

class AdminStudentsViewModel: AdminTableViewModelProtocol {

    var onDataFetched: (() -> Void)?
    var onShowError: ((String) -> Void)?

    var originalCells: [AdminTableCellModel] = []
    var cells: [AdminTableCellModel] = []

    func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            originalCells = [
                AdminTableCellModel(
                    data: [
                        AdminTableCellDataModel(value: "Bassam Hillo"),
                        AdminTableCellDataModel(value: "Software Project"),
                        AdminTableCellDataModel(value: "Anas Tomeh"),
                        AdminTableCellDataModel(value: "1234")
                    ]
                ),
                AdminTableCellModel(
                    data: [
                        AdminTableCellDataModel(value: "Mayar Abdulkareem"),
                        AdminTableCellDataModel(value: "Software Project"),
                        AdminTableCellDataModel(value: "Anas Tomeh"),
                        AdminTableCellDataModel(value: "1234")
                    ]
                ),
                AdminTableCellModel(
                    data: [
                        AdminTableCellDataModel(value: "Nora Sader"),
                        AdminTableCellDataModel(value: "Software Project"),
                        AdminTableCellDataModel(value: "Anas Tomeh"),
                        AdminTableCellDataModel(value: "1234")
                    ]
                ),
                AdminTableCellModel(
                    data: [
                        AdminTableCellDataModel(value: "Noura Hashem"),
                        AdminTableCellDataModel(value: "Software Project"),
                        AdminTableCellDataModel(value: "Anas Tomeh"),
                        AdminTableCellDataModel(value: "1234")
                    ]
                )
            ]
            cells = originalCells
            self.onDataFetched?()
        }
    }

    func search(text: String) {
        if text.isEmpty {
            cells = originalCells
        } else {
            cells = originalCells.filter {
                $0.data[0].value?.lowercased().contains(text.lowercased()) ?? false
            }
        }
        onDataFetched?()
    }

    func getNavTitle() -> String {
        "Students"
    }
}
