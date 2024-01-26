//
//  AdminProfessorsViewController.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import UIKit

class AdminProfessorsViewController: AdminTableViewController {

    init() {
        let viewModel = AdminProfessorsViewModel()
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        print("Professor cell selected")
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
            
            guard let viewModel = self.viewModel as? AdminProfessorsViewModel else { return }
            viewModel.delete(at: indexPath.row)
        }

        let availabilityAction = UIContextualAction(
            style: .normal,
            title: "Available"
        ) { (action, view, completionHandler) in
            completionHandler(true)
            print("Available: \(indexPath.row)")
        }

        availabilityAction.backgroundColor = .systemBlue

        let configuration = UISwipeActionsConfiguration(
            actions: [
                deleteAction,
                availabilityAction
            ]
        )
        return configuration
    }
}
