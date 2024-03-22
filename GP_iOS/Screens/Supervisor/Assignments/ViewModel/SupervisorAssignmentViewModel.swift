//
//  SupervisorAssignmentViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/01/2024.
//

import UIKit.UIColor

class SupervisorAssignmentViewModel: AdminTableViewModelProtocol {

    var onDataFetched: (() -> Void)?
    var onShowError: ((String) -> Void)?

    var assignmentID: String
    var submissions: [SupervisorSubmissoins]?

    var originalCells: [AdminTableCellModel] = []
    var cells: [AdminTableCellModel] = []

    init(assignmentID: String) {
        self.assignmentID = assignmentID
    }

    func configureCells() {
        guard let submissions = self.submissions else { return }

        for submission in submissions {

            var status: String
            var textColor: UIColor

            if let comment = submission.supervisorComment {
                status = "Marked"
                textColor = .mySecondary
            } else {
                status = "Not Marked"
                textColor = .systemRed
            }

            originalCells.append(AdminTableCellModel(data: [
                AdminTableCellDataModel(value: submission.studentName),
                AdminTableCellDataModel(value: "Peer Name: " + (submission.peerName?.isEmpty == true ? "No Peer" : submission.peerName ?? "No Peer")),
                AdminTableCellDataModel(value: status , textColor: textColor)
            ]))
        }

        cells = originalCells
    }

    func getData() {
        guard let regID = AuthManager.shared.regID else { return }
        let route = SubmissionsRouter.getSupervisorSubmissions(assignmentID: assignmentID, supervisorID: regID)
        BaseClient.shared.performRequest(router: route, type: [SupervisorSubmissoins].self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.submissions = data
                self?.configureCells()
                self?.onDataFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
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
        "Submissions"
    }
}

