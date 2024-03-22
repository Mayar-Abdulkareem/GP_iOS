//
//  AdminAssigmentViewController.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import UIKit

class AdminAssigmentViewController: AdminTableViewController {

    init() {
        let viewModel = AdminAssigmentsViewModel()
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        print("Assignment cell selected")
    }
}
