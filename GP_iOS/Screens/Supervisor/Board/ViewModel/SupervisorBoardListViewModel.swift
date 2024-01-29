//
//  SupervisorBoardListViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/01/2024.
//

import Foundation

class SupervisorBoardListViewModel: AdminTableViewModelProtocol {

    var onDataFetched: (() -> Void)?
    var onShowError: ((String) -> Void)?

    var originalCells: [AdminTableCellModel] = []
    var cells: [AdminTableCellModel] = []

    func configureCells() {
        guard let students = AppManager.shared.courseStudents?.students else { return }

        for student in students {

            originalCells.append(AdminTableCellModel(data: [
                AdminTableCellDataModel(value: student.name),
                AdminTableCellDataModel(value: "Student ID: " + student.id)
            ]))
        }
        cells = originalCells
        onDataFetched?()
    }

    func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.configureCells()
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
        "Board"
    }
}
