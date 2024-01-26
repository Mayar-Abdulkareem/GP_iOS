//
//  AdminCoursesViewModel.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import Foundation

class AdminCoursesViewModel: AdminTableViewModelProtocol {

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
                        AdminTableCellDataModel(value: "Software Project"),
                        AdminTableCellDataModel(value: "1"),
                        AdminTableCellDataModel(value: "Available", textColor: .systemGreen),
                    ]
                ),
                AdminTableCellModel(
                    data: [
                        AdminTableCellDataModel(value: "Hardware Project"),
                        AdminTableCellDataModel(value: "1"),
                        AdminTableCellDataModel(value: "Not available", textColor: .systemRed),
                    ]
                ),
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
        "Courses"
    }

    func getFooterButtonTitle() -> String? {
        "ADD"
    }

    func primaryButtonTapped() {
        onShowError?("Primary button tapped")
    }
}
