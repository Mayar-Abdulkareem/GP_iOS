//
//  SupervisorAssignmentViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/01/2024.
//

import UIKit

class SupervisorAssignmentViewController: AdminTableViewController {

    init() {
        let viewModel = SupervisorAssignmentViewModel(assignmentID: AppManager.shared.assignment?.id ?? "")
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if let supervisorViewModel = viewModel as? SupervisorAssignmentViewModel {
            let selectedSubmission = supervisorViewModel.submissions?[indexPath.row]
            AppManager.shared.selectedSubmission = selectedSubmission

            let submissionViewController = SubmissionViewController()
            navigationController?.pushViewController(submissionViewController, animated: true)
        }
    }
}
