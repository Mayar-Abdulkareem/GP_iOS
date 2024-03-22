//
//  AdminStudentsViewController.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import UIKit

class AdminStudentsViewController: AdminTableViewController {
    
    init() {
        let viewModel = AdminStudentsViewModel()
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        print("Student cell selected")
    }

    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { (action, view, completionHandler) in
            completionHandler(true)
            print("Delete: \(indexPath.row)")
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
