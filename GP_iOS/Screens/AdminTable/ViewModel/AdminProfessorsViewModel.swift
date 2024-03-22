//
//  AdminProfessorsViewModel.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import Foundation

class AdminProfessorsViewModel: AdminTableViewModelProtocol {

    var onDataFetched: (() -> Void)?
    var onShowError: ((String) -> Void)?
    
    var originalCells: [AdminTableCellModel] = []
    var cells: [AdminTableCellModel] = []

    func getData() {
        originalCells = [
            AdminTableCellModel(
                data: [
                    AdminTableCellDataModel(value: "Bassam Hillo"),
                    AdminTableCellDataModel(value: "1234"),
                    AdminTableCellDataModel(value: "Available", textColor: .systemGreen),
                ]
            ),
            AdminTableCellModel(
                data: [
                    AdminTableCellDataModel(value: "Nora Sader"),
                    AdminTableCellDataModel(value: "1"),
                    AdminTableCellDataModel(value: "Available", textColor: .systemGreen),
                ]
            ),
            AdminTableCellModel(
                data: [
                    AdminTableCellDataModel(value: "Noura Hashem"),
                    AdminTableCellDataModel(value: "1234"),
                    AdminTableCellDataModel(value: "Available", textColor: .systemGreen)

                ]
            ),
            AdminTableCellModel(
                data: [
                    AdminTableCellDataModel(value: "Mayar Abdulkareem"),
                    AdminTableCellDataModel(value: "1234"),
                    AdminTableCellDataModel(value: "Not Available", textColor: .systemRed)
                ]
            )
        ]
        cells = originalCells
        onDataFetched?()
    }
    
    func getNavTitle() -> String {
        "Professors"
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

    func delete(at index: Int) {

    }
}
