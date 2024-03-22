//
//  SupervisorBoardListViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/01/2024.
//

import UIKit

class SupervisorBoardListViewController: AdminTableViewController {

    weak var coordinator: BoardCoordinator?

    init() {
        let viewModel = SupervisorBoardListViewModel()
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        AppManager.shared.selectedStudent = AppManager.shared.courseStudents?.students?[indexPath.row].id
        coordinator?.showBoardViewController()
    }
}
