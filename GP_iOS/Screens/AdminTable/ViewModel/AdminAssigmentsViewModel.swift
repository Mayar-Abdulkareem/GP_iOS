//
//  AdminAssigmentsViewModel.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import Foundation

class AdminAssigmentsViewModel: AdminTableViewModelProtocol {

    var onDataFetched: (() -> Void)?
    var onShowError: ((String) -> Void)?
    
    var cells: [AdminTableCellModel] = []

    func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            cells = [
                AdminTableCellModel(data: [
                    AdminTableCellDataModel(value: "Samer Aranidi"),
                    AdminTableCellDataModel(value: "Bassam Hillo: 11534892"),
                    AdminTableCellDataModel(value: "Mayar Abdulhakeem: 11534892"),
                    AdminTableCellDataModel(value: "MArked", textColor: .systemGreen)
                ]),
                AdminTableCellModel(data: [
                    AdminTableCellDataModel(value: "Samer Aranidi"),
                    AdminTableCellDataModel(value: "Bassam Hillo: 11534892"),
                    AdminTableCellDataModel(value: "Mayar Abdulhakeem: 11534892"),
                    AdminTableCellDataModel(value: "MArked", textColor: .systemGreen)
                ]),
                AdminTableCellModel(data: [
                    AdminTableCellDataModel(value: "Samer Aranidi"),
                    AdminTableCellDataModel(value: "Bassam Hillo: 11534892"),
                    AdminTableCellDataModel(value: "Mayar Abdulhakeem: 11534892"),
                    AdminTableCellDataModel(value: "MArked", textColor: .systemGreen)
                ])
            ]
            onDataFetched?()
        }
    }
    
    func getNavTitle() -> String {
        "Assignments"
    }
    
    func search(text: String) {}
}
